/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* utilities for regression tests based on frame tree comparison */

#include "nsIFrameUtil.h"
#include "nsFrame.h"
#include "nsString.h"
#include "nsRect.h"
#include <stdlib.h>
#include "plstr.h"


#ifdef DEBUG
class nsFrameUtil : public nsIFrameUtil {
protected:
  virtual ~nsFrameUtil();

public:
  nsFrameUtil();

  NS_DECL_ISUPPORTS

  NS_IMETHOD CompareRegressionData(FILE* aFile1, FILE* aFile2,int32_t aRegressionOutput=0) override;
  NS_IMETHOD DumpRegressionData(FILE* aInputFile, FILE* aOutputFile) override;

  struct Node;
  struct Tag;

  struct NodeList {
    NodeList();
    ~NodeList();

    static void Destroy(NodeList* aLists);

    NodeList* next;            // for lists of lists
    Node* node;
    char* name;
  };

  struct Node {
    Node();
    ~Node();

    static void Destroy(Node* aNode);

    static Node* Read(FILE* aFile, Tag* aTag);

    static Node* ReadTree(FILE* aFile);

    Node* next;
    char* type;
    uint32_t state;
    nsRect bbox;
    nsCString styleData;
    NodeList* lists;
  };

  struct Tag {
    Tag();
    ~Tag();

    static Tag* Parse(FILE* aFile);

    void AddAttr(char* aAttr, char* aValue);

    const char* GetAttr(const char* aAttr);

    void ReadAttrs(FILE* aFile);

    void ToString(nsString& aResult);

    enum Type {
      open,
      close,
      openClose
    };

    char* name;
    Type type;
    char** attributes;
    int32_t num;
    int32_t size;
    char** values;
  };

  static char* Copy(const char* aString);

  static void DumpNode(Node* aNode, FILE* aOutputFile, int32_t aIndent);
  static void DumpTree(Node* aNode, FILE* aOutputFile, int32_t aIndent);
  static bool CompareTrees(Node* aNode1, Node* aNode2);
};

char*
nsFrameUtil::Copy(const char* aString)
{
  if (aString) {
    int l = ::strlen(aString);
    char* c = new char[l+1];
    if (!c)
      return nullptr;
    memcpy(c, aString, l+1);
    return c;
  }
  return nullptr;
}

//----------------------------------------------------------------------

nsFrameUtil::NodeList::NodeList()
  : next(nullptr), node(nullptr), name(nullptr)
{
}

nsFrameUtil::NodeList::~NodeList()
{
  if (nullptr != name) {
    delete name;
  }
  if (nullptr != node) {
    Node::Destroy(node);
  }
}

void
nsFrameUtil::NodeList::Destroy(NodeList* aLists)
{
  while (nullptr != aLists) {
    NodeList* next = aLists->next;
    delete aLists;
    aLists = next;
  }
}

//----------------------------------------------------------------------

nsFrameUtil::Node::Node()
  : next(nullptr), type(nullptr), state(0), lists(nullptr)
{
}

nsFrameUtil::Node::~Node()
{
  if (nullptr != type) {
    delete type;
  }
  if (nullptr != lists) {
    NodeList::Destroy(lists);
  }
}

void
nsFrameUtil::Node::Destroy(Node* aList)
{
  while (nullptr != aList) {
    Node* next = aList->next;
    delete aList;
    aList = next;
  }
}

static int32_t GetInt(nsFrameUtil::Tag* aTag, const char* aAttr)
{
  const char* value = aTag->GetAttr(aAttr);
  if (nullptr != value) {
    return int32_t( atoi(value) );
  }
  return 0;
}

nsFrameUtil::Node*
nsFrameUtil::Node::ReadTree(FILE* aFile)
{
  Tag* tag = Tag::Parse(aFile);
  if (nullptr == tag) {
    return nullptr;
  }
  if (PL_strcmp(tag->name, "frame") != 0) {
    delete tag;
    return nullptr;
  }
  Node* result = Read(aFile, tag);
  fclose(aFile);
  return result;
}

nsFrameUtil::Node*
nsFrameUtil::Node::Read(FILE* aFile, Tag* tag)
{
  Node* node = new Node;
  node->type = Copy(tag->GetAttr("type"));
  if (!node->type) {
    /* crash() */
  }
  node->state = GetInt(tag, "state");
  delete tag;

  for (;;) {
    tag = Tag::Parse(aFile);
    if (nullptr == tag) break;
    if (PL_strcmp(tag->name, "frame") == 0) {
      delete tag;
      break;
    }
    if (PL_strcmp(tag->name, "bbox") == 0) {
      nscoord x = nscoord( GetInt(tag, "x") );
      nscoord y = nscoord( GetInt(tag, "y") );
      nscoord w = nscoord( GetInt(tag, "w") );
      nscoord h = nscoord( GetInt(tag, "h") );
      node->bbox.SetRect(x, y, w, h);
    }
    else if (PL_strcmp(tag->name, "child-list") == 0) {
      NodeList* list = new NodeList();
      list->name = Copy(tag->GetAttr("name"));
      if (!list->name) {
        /* crash() */
      }
      list->next = node->lists;
      node->lists = list;
      delete tag;

      Node** tailp = &list->node;
      for (;;) {
        tag = Tag::Parse(aFile);
        if (nullptr == tag) {
          break;
        }
        if (PL_strcmp(tag->name, "child-list") == 0) {
          break;
        }
        if (PL_strcmp(tag->name, "frame") != 0) {
          break;
        }
        Node* child = Node::Read(aFile, tag);
        if (nullptr == child) {
          break;
        }
        *tailp = child;
        tailp = &child->next;
      }
    }
    else if((PL_strcmp(tag->name, "font") == 0) ||
            (PL_strcmp(tag->name, "color") == 0) ||
            (PL_strcmp(tag->name, "spacing") == 0) ||
            (PL_strcmp(tag->name, "list") == 0) ||
            (PL_strcmp(tag->name, "position") == 0) ||
            (PL_strcmp(tag->name, "text") == 0) ||
            (PL_strcmp(tag->name, "display") == 0) ||
            (PL_strcmp(tag->name, "table") == 0) ||
            (PL_strcmp(tag->name, "content") == 0) ||
            (PL_strcmp(tag->name, "UI") == 0) ||
            (PL_strcmp(tag->name, "print") == 0)) {
      const char* attr = tag->GetAttr("data");
      node->styleData.Append('|');
      node->styleData.Append(attr ? attr : "null attr");
    }

    delete tag;
  }
  return node;
}

//----------------------------------------------------------------------

nsFrameUtil::Tag::Tag()
  : name(nullptr), type(open), attributes(nullptr), num(0), size(0),
    values(nullptr)
{
}

nsFrameUtil::Tag::~Tag()
{
  int32_t i, n = num;
  if (0 != n) {
    for (i = 0; i < n; i++) {
      delete attributes[i];
      delete values[i];
    }
    delete attributes;
    delete values;
  }
}

void
nsFrameUtil::Tag::AddAttr(char* aAttr, char* aValue)
{
  if (num == size) {
    int32_t newSize = size * 2 + 4;
    char** a = new char*[newSize];
    char** v = new char*[newSize];
    if (0 != num) {
      memcpy(a, attributes, num * sizeof(char*));
      memcpy(v, values, num * sizeof(char*));
      delete attributes;
      delete values;
    }
    attributes = a;
    values = v;
    size = newSize;
  }
  attributes[num] = aAttr;
  values[num] = aValue;
  num = num + 1;
}

const char*
nsFrameUtil::Tag::GetAttr(const char* aAttr)
{
  int32_t i, n = num;
  for (i = 0; i < n; i++) {
    if (PL_strcmp(attributes[i], aAttr) == 0) {
      return values[i];
    }
  }
  return nullptr;
}

static inline int IsWhiteSpace(int c) {
  return (c == ' ') || (c == '\t') || (c == '\n') || (c == '\r');
}

static bool EatWS(FILE* aFile)
{
  for (;;) {
    int c = getc(aFile);
    if (c < 0) {
      return false;
    }
    if (!IsWhiteSpace(c)) {
      ungetc(c, aFile);
      break;
    }
  }
  return true;
}

static bool Expect(FILE* aFile, char aChar)
{
  int c = getc(aFile);
  if (c < 0) return false;
  if (c != aChar) {
    ungetc(c, aFile);
    return false;
  }
  return true;
}

static char* ReadIdent(FILE* aFile)
{
  char id[1000];
  char* ip = id;
  char* end = ip + sizeof(id) - 1;
  while (ip < end) {
    int c = fgetc(aFile);
    if (c < 0) return nullptr;
    if ((c == '=') || (c == '>') || (c == '/') || IsWhiteSpace(c)) {
      ungetc(c, aFile);
      break;
    }
    *ip++ = char(c);
  }
  *ip = '\0';
  return nsFrameUtil::Copy(id);
  /* may return a null pointer */
}

static char* ReadString(FILE* aFile)
{
  if (!Expect(aFile, '\"')) {
    return nullptr;
  }
  char id[1000];
  char* ip = id;
  char* end = ip + sizeof(id) - 1;
  while (ip < end) {
    int c = fgetc(aFile);
    if (c < 0) return nullptr;
    if (c == '\"') {
      break;
    }
    *ip++ = char(c);
  }
  *ip = '\0';
  return nsFrameUtil::Copy(id);
  /* may return a null pointer */
}

void
nsFrameUtil::Tag::ReadAttrs(FILE* aFile)
{
  for (;;) {
    if (!EatWS(aFile)) {
      break;
    }
    int c = getc(aFile);
    if (c < 0) break;
    if (c == '/') {
      if (!EatWS(aFile)) {
        return;
      }
      if (Expect(aFile, '>')) {
        type = openClose;
        break;
      }
    }
    else if (c == '>') {
      break;
    }
    ungetc(c, aFile);
    char* attr = ReadIdent(aFile);
    if ((nullptr == attr) || !EatWS(aFile)) {
      break;
    }
    char* value = nullptr;
    if (Expect(aFile, '=')) {
      value = ReadString(aFile);
      if (nullptr == value) {
        delete [] attr;
        break;
      }
    }
    AddAttr(attr, value);
  }
}

nsFrameUtil::Tag*
nsFrameUtil::Tag::Parse(FILE* aFile)
{
  if (!EatWS(aFile)) {
    return nullptr;
  }
  if (Expect(aFile, '<')) {
    Tag* tag = new Tag;
    if (Expect(aFile, '/')) {
      tag->type = close;
    }
    else {
      tag->type = open;
    }
    tag->name = ReadIdent(aFile);
    tag->ReadAttrs(aFile);
    return tag;
  }
  return nullptr;
}

void
nsFrameUtil::Tag::ToString(nsString& aResult)
{
  aResult.Truncate();
  aResult.Append(char16_t('<'));
  if (type == close) {
    aResult.Append(char16_t('/'));
  }
  aResult.AppendASCII(name);
  if (0 != num) {
    int32_t i, n = num;
    for (i = 0; i < n; i++) {
      aResult.Append(char16_t(' '));
      aResult.AppendASCII(attributes[i]);
      if (values[i]) {
        aResult.AppendLiteral("=\"");
        aResult.AppendASCII(values[i]);
        aResult.Append(char16_t('\"'));
      }
    }
  }
  if (type == openClose) {
    aResult.Append(char16_t('/'));
  }
  aResult.Append(char16_t('>'));
}

//----------------------------------------------------------------------

nsresult
NS_NewFrameUtil(nsIFrameUtil** aResult)
{
  NS_PRECONDITION(nullptr != aResult, "null pointer");
  if (nullptr == aResult) {
    return NS_ERROR_NULL_POINTER;
  }

  nsFrameUtil* it = new nsFrameUtil();

  NS_ADDREF(*aResult = it);
  return NS_OK;
}

nsFrameUtil::nsFrameUtil()
{
}

nsFrameUtil::~nsFrameUtil()
{
}

NS_IMPL_ISUPPORTS(nsFrameUtil, nsIFrameUtil)

void
nsFrameUtil::DumpNode(Node* aNode, FILE* aOutputFile, int32_t aIndent)
{
  nsFrame::IndentBy(aOutputFile, aIndent);
  fprintf(aOutputFile, "%s 0x%x %d,%d,%d,%d, %s\n", aNode->type, aNode->state,
          aNode->bbox.x, aNode->bbox.y,
          aNode->bbox.width, aNode->bbox.height,
          aNode->styleData.get());
}

void
nsFrameUtil::DumpTree(Node* aNode, FILE* aOutputFile, int32_t aIndent)
{
  while (nullptr != aNode) {
    DumpNode(aNode, aOutputFile, aIndent);
    nsFrameUtil::NodeList* lists = aNode->lists;
    if (nullptr != lists) {
      while (nullptr != lists) {
        nsFrame::IndentBy(aOutputFile, aIndent);
        fprintf(aOutputFile, " list: %s\n",
                lists->name ? lists->name : "primary");
        DumpTree(lists->node, aOutputFile, aIndent + 1);
        lists = lists->next;
      }
    }
    aNode = aNode->next;
  }
}

bool
nsFrameUtil::CompareTrees(Node* tree1, Node* tree2)
{
  bool result = true;
  for (;; tree1 = tree1->next, tree2 = tree2->next) {
    // Make sure both nodes are non-null, or at least agree with each other
    if (nullptr == tree1) {
      if (nullptr == tree2) {
        break;
      }
      printf("first tree prematurely ends\n");
      return false;
    }
    else if (nullptr == tree2) {
      printf("second tree prematurely ends\n");
      return false;
    }

    // Check the attributes that we care about
    if (0 != PL_strcmp(tree1->type, tree2->type)) {
      printf("frame type mismatch: %s vs. %s\n", tree1->type, tree2->type);
      printf("Node 1:\n");
      DumpNode(tree1, stdout, 1);
      printf("Node 2:\n");
      DumpNode(tree2, stdout, 1);
      return false;
    }

    // Ignore the XUL scrollbar frames
    static const char kScrollbarFrame[] = "ScrollbarFrame";
    if (0 == PL_strncmp(tree1->type, kScrollbarFrame, sizeof(kScrollbarFrame) - 1))
      continue;

    if (tree1->state != tree2->state) {
      printf("frame state mismatch: 0x%x vs. 0x%x\n",
             tree1->state, tree2->state);
      printf("Node 1:\n");
      DumpNode(tree1, stdout, 1);
      printf("Node 2:\n");
      DumpNode(tree2, stdout, 1);
      result = false; // we have a non-critical failure, so remember that but continue
    }
    if (tree1->bbox.IsEqualInterior(tree2->bbox)) {
      printf("frame bbox mismatch: %d,%d,%d,%d vs. %d,%d,%d,%d\n",
             tree1->bbox.x, tree1->bbox.y,
             tree1->bbox.width, tree1->bbox.height,
             tree2->bbox.x, tree2->bbox.y,
             tree2->bbox.width, tree2->bbox.height);
      printf("Node 1:\n");
      DumpNode(tree1, stdout, 1);
      printf("Node 2:\n");
      DumpNode(tree2, stdout, 1);
      result = false; // we have a non-critical failure, so remember that but continue
    }
    if (tree1->styleData != tree2->styleData) {
      printf("frame style data mismatch: %s vs. %s\n",
        tree1->styleData.get(),
        tree2->styleData.get());
    }

    // Check child lists too
    NodeList* list1 = tree1->lists;
    NodeList* list2 = tree2->lists;
    for (;;) {
      if (nullptr == list1) {
        if (nullptr != list2) {
          printf("first tree prematurely ends (no child lists)\n");
          printf("Node 1:\n");
          DumpNode(tree1, stdout, 1);
          printf("Node 2:\n");
          DumpNode(tree2, stdout, 1);
          return false;
        }
        else {
          break;
        }
      }
      if (nullptr == list2) {
        printf("second tree prematurely ends (no child lists)\n");
        printf("Node 1:\n");
        DumpNode(tree1, stdout, 1);
        printf("Node 2:\n");
        DumpNode(tree2, stdout, 1);
        return false;
      }
      if (0 != PL_strcmp(list1->name, list2->name)) {
        printf("child-list name mismatch: %s vs. %s\n",
               list1->name ? list1->name : "(null)",
               list2->name ? list2->name : "(null)");
        result = false; // we have a non-critical failure, so remember that but continue
      }
      else {
        bool equiv = CompareTrees(list1->node, list2->node);
        if (!equiv) {
          return equiv;
        }
      }
      list1 = list1->next;
      list2 = list2->next;
    }
  }
  return result;
}

NS_IMETHODIMP
nsFrameUtil::CompareRegressionData(FILE* aFile1, FILE* aFile2,int32_t aRegressionOutput)
{
  Node* tree1 = Node::ReadTree(aFile1);
  Node* tree2 = Node::ReadTree(aFile2);

  nsresult rv = NS_OK;
  if (!CompareTrees(tree1, tree2)) {
    // only output this if aRegressionOutput is 0
    if( 0 == aRegressionOutput ){
      printf("Regression data 1:\n");
      DumpTree(tree1, stdout, 0);
      printf("Regression data 2:\n");
      DumpTree(tree2, stdout, 0);
    }
    rv = NS_ERROR_FAILURE;
  }

  Node::Destroy(tree1);
  Node::Destroy(tree2);

  return rv;
}

NS_IMETHODIMP
nsFrameUtil::DumpRegressionData(FILE* aInputFile, FILE* aOutputFile)
{
  Node* tree1 = Node::ReadTree(aInputFile);
  if (nullptr != tree1) {
    DumpTree(tree1, aOutputFile, 0);
    Node::Destroy(tree1);
    return NS_OK;
  }
  return NS_ERROR_FAILURE;
}
#endif
