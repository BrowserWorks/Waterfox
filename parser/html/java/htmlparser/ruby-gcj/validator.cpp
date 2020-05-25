#include <gcj/cni.h>

#include <java/io/ByteArrayInputStream.h>
#include <java/lang/System.h>
#include <java/lang/Throwable.h>
#include <java/util/ArrayList.h>
#include <javax/xml/xpath/XPath.h>
#include <javax/xml/xpath/XPathFactory.h>
#include <javax/xml/xpath/XPathExpression.h>
#include <javax/xml/xpath/XPathConstants.h>
#include <javax/xml/parsers/DocumentBuilderFactory.h>
#include <javax/xml/parsers/DocumentBuilder.h>
#include <org/w3c/dom/Attr.h>
#include <org/w3c/dom/Document.h>
#include <org/w3c/dom/Element.h>
#include <org/w3c/dom/NodeList.h>
#include <org/w3c/dom/NamedNodeMap.h>
#include <org/xml/sax/InputSource.h>

#include "nu/validator/htmlparser/dom/HtmlDocumentBuilder.h"

#include "DomUtils.h"

#include "ruby.h"

using namespace java::io;
using namespace java::lang;
using namespace java::util;
using namespace javax::xml::parsers;
using namespace javax::xml::xpath;
using namespace nu::validator::htmlparser::dom;
using namespace org::w3c::dom;
using namespace org::xml::sax;

static VALUE jaxp_Document;
static VALUE jaxp_Attr;
static VALUE jaxp_Element;
static ID ID_read;
static ID ID_doc;
static ID ID_element;

// convert a Java string into a Ruby string
static VALUE j2r(String *string) {
  if (string == NULL) return Qnil;
  jint len = JvGetStringUTFLength(string);
  char buf[len];
  JvGetStringUTFRegion(string, 0, len, buf);
  return rb_str_new(buf, len);
}

// convert a Ruby string into a Java string
static String *r2j(VALUE string) {
  return JvNewStringUTF(RSTRING(string)->ptr);
}

// release the Java Document associated with this Ruby Document
static void vnu_document_free(Document *doc) {
  DomUtils::unpin(doc);
}

// Nu::Validator::parse( string|file )
static VALUE vnu_parse(VALUE self, VALUE input) {
  HtmlDocumentBuilder *parser = new HtmlDocumentBuilder();
  
  // read file-like objects into memory.  TODO: buffer such objects
  if (rb_respond_to(input, ID_read))
    input = rb_funcall(input, ID_read, 0);

  // convert input in to a ByteArrayInputStream
  jbyteArray bytes = JvNewByteArray(RSTRING(input)->len);
  memcpy(elements(bytes), RSTRING(input)->ptr, RSTRING(input)->len);
  InputSource *source = new InputSource(new ByteArrayInputStream(bytes));

  // parse, pin, and wrap
  Document *doc = parser->parse(source);
  DomUtils::pin(doc);
  return Data_Wrap_Struct(jaxp_Document, NULL, vnu_document_free, doc);
}

// Jaxp::parse( string|file )
static VALUE jaxp_parse(VALUE self, VALUE input) {
  DocumentBuilderFactory *factory = DocumentBuilderFactory::newInstance();
  DocumentBuilder *parser = factory->newDocumentBuilder();
   
  // read file-like objects into memory.  TODO: buffer such objects
  if (rb_respond_to(input, ID_read))
    input = rb_funcall(input, ID_read, 0);
 
  try {
    jbyteArray bytes = JvNewByteArray(RSTRING(input)->len);
    memcpy(elements(bytes), RSTRING(input)->ptr, RSTRING(input)->len);
    Document *doc = parser->parse(new ByteArrayInputStream(bytes));
    DomUtils::pin(doc);
    return Data_Wrap_Struct(jaxp_Document, NULL, vnu_document_free, doc);
  } catch (java::lang::Throwable *ex) {
    ex->printStackTrace();
    return Qnil;
  }
}


// Nu::Validator::Document#encoding
static VALUE jaxp_document_encoding(VALUE rdoc) {
  Document *jdoc;
  Data_Get_Struct(rdoc, Document, jdoc);
  return j2r(jdoc->getXmlEncoding());
}

// Nu::Validator::Document#root
static VALUE jaxp_document_root(VALUE rdoc) {
  Document *jdoc;
  Data_Get_Struct(rdoc, Document, jdoc);

  Element *jelement = jdoc->getDocumentElement();
  if (jelement==NULL) return Qnil;

  VALUE relement = Data_Wrap_Struct(jaxp_Element, NULL, NULL, jelement);
  rb_ivar_set(relement, ID_doc, rdoc);
  return relement;
}

// Nu::Validator::Document#xpath
static VALUE jaxp_document_xpath(VALUE rdoc, VALUE path) {
  Document *jdoc;
  Data_Get_Struct(rdoc, Document, jdoc);

  Element *jelement = jdoc->getDocumentElement();
  if (jelement==NULL) return Qnil;

  XPath *xpath = XPathFactory::newInstance()->newXPath();
  XPathExpression *expr = xpath->compile(r2j(path));
  NodeList *list = (NodeList*) expr->evaluate(jdoc, XPathConstants::NODESET);

  VALUE result = rb_ary_new();
  for (int i=0; i<list->getLength(); i++) {
    VALUE relement = Data_Wrap_Struct(jaxp_Element, NULL, NULL, list->item(i));
    rb_ivar_set(relement, ID_doc, rdoc);
    rb_ary_push(result, relement);
  }
  return result;
}

// Nu::Validator::Element#name
static VALUE jaxp_element_name(VALUE relement) {
  Element *jelement;
  Data_Get_Struct(relement, Element, jelement);
  return j2r(jelement->getNodeName());
}

// Nu::Validator::Element#attributes
static VALUE jaxp_element_attributes(VALUE relement) {
  Element *jelement;
  Data_Get_Struct(relement, Element, jelement);
  VALUE result = rb_hash_new();
  NamedNodeMap *map = jelement->getAttributes();
  for (int i=0; i<map->getLength(); i++) {
    Attr *jattr = (Attr *) map->item(i);
    VALUE rattr = Data_Wrap_Struct(jaxp_Attr, NULL, NULL, jattr);
    rb_ivar_set(rattr, ID_element, relement);
    rb_hash_aset(result, j2r(jattr->getName()), rattr);
  }
  return result;
}

// Nu::Validator::Attribute#value
static VALUE jaxp_attribute_value(VALUE rattribute) {
  Attr *jattribute;
  Data_Get_Struct(rattribute, Attr, jattribute);
  return j2r(jattribute->getValue());
}

typedef VALUE (ruby_method)(...);

// Nu::Validator module initialization
extern "C" void Init_validator() {
  JvCreateJavaVM(NULL);
  JvAttachCurrentThread(NULL, NULL);
  JvInitClass(&DomUtils::class$);
  JvInitClass(&XPathFactory::class$);
  JvInitClass(&XPathConstants::class$);

  VALUE jaxp = rb_define_module("Jaxp");
  rb_define_singleton_method(jaxp, "parse", (ruby_method*)&jaxp_parse, 1);

  VALUE nu = rb_define_module("Nu");
  VALUE validator = rb_define_module_under(nu, "Validator");
  rb_define_singleton_method(validator, "parse", (ruby_method*)&vnu_parse, 1);

  jaxp_Document = rb_define_class_under(jaxp, "Document", rb_cObject);
  rb_define_method(jaxp_Document, "encoding", 
    (ruby_method*)&jaxp_document_encoding, 0);
  rb_define_method(jaxp_Document, "root", 
    (ruby_method*)&jaxp_document_root, 0);
  rb_define_method(jaxp_Document, "xpath", 
    (ruby_method*)&jaxp_document_xpath, 1);

  jaxp_Element = rb_define_class_under(jaxp, "Element", rb_cObject);
  rb_define_method(jaxp_Element, "name", 
    (ruby_method*)&jaxp_element_name, 0);
  rb_define_method(jaxp_Element, "attributes", 
    (ruby_method*)&jaxp_element_attributes, 0);

  jaxp_Attr = rb_define_class_under(jaxp, "Attr", rb_cObject);
  rb_define_method(jaxp_Attr, "value", 
    (ruby_method*)&jaxp_attribute_value, 0);

  ID_read = rb_intern("read");
  ID_doc  = rb_intern("@doc");
  ID_element = rb_intern("@element");
}
