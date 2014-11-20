#include <gst/gst.h>

static gchar *_subject, *_category;
static gint _testnum = 0;
static gboolean _passed;
static gint _total_tests = 0, _passed_tests = 0;
static gint _random_size;

void
tabpad (gchar * str, gint width)
{
  int i;

  for (i = 0; i < width - strlen (str); i++)
    fprintf (stderr, " ");
}

#define TEST_SUBJECT(subject) fprintf(stderr,"Subject: %s\n",subject),_subject = subject
#define TEST_CATEGORY(category) fprintf(stderr,"\n\nCategory: %s\n",category)

#define TEST(test) fprintf(stderr,"Test %d: %s...\n",_testnum,test),_passed = TRUE
#define ASSERT(expr) G_STMT_START{                              \
  fprintf(stderr,"\t%s:",#expr);tabpad(#expr,50);               \
  if (!(expr)) {                                                \
    fprintf(stderr,"FAILED\n");                                 \
    _passed = FALSE;                                            \
  } else {                                                      \
    fprintf(stderr,"passed\n");                                 \
  }                                                             \
}G_STMT_END;
#define ENDTEST() G_STMT_START{                 \
  _testnum++;                                   \
  if (_passed) {                                \
    fprintf(stderr,"\tpassed.\n");              \
    _passed_tests++;                            \
  } else {                                      \
    fprintf(stderr,"\tFAILED.\n");              \
  }                                             \
  _total_tests++;                               \
}G_STMT_END;

void
SETUP_RANDOM_SIZE (void *random, gint size)
{
  int i;

  if (random)
    g_free (random);
  _random_size = size;
  random = g_malloc (_random_size);
  for (i = 0; i < _random_size; i++)
    ((unsigned char *) random)[i] = i;
}

#define SETUP_RANDOM(random,type) SETUP_RANDOM_SIZE(random,sizeof(type))

gboolean
RANDOM_OK (void *random)
{
  int i;

  for (i = 0; i < _random_size; i++) {
    if (((unsigned char *) random)[i] != i) {
      SETUP_RANDOM_SIZE (random, _random_size);
      return FALSE;
    }
  }
  return TRUE;
}

int
main (int argc, char *argv[])
{
  GstObject *object;
  GstObject *parent;
  GstObject *newparent;
  GtkObject *gtkobject;
  GstObject *curparent;

  gst_init (&argc, &argv);

  TEST_SUBJECT ("GstObject");


  TEST_CATEGORY ("Creation");

  TEST ("create object");
  /* setup */
  /* action */
  object = gst_object_new ();
  /* assertions */
  ASSERT (object != NULL);
  ASSERT (GST_IS_OBJECT (object));
  /* cleanup */
  g_free (object);
  ENDTEST ();


  /* new category */
  TEST_CATEGORY ("Refcounting");
  /* category setup */
  object = gst_object_new ();

  TEST ("new object");
  /* setup */
  /* action */
  /* assertions */
  ASSERT (object->refcount == 1);
  ASSERT (GTK_OBJECT_FLOATING (object) == TRUE);
  /* cleanup */
  ENDTEST ();

  TEST ("increment refcount");
  /* setup */
  /* action */
  gst_object_ref (object);
  /* assertions */
  ASSERT (object->refcount == 2);
  ASSERT (GTK_OBJECT_FLOATING (object) == TRUE);
  /* cleanup */
  ENDTEST ();

  TEST ("sink object");
  /* setup */
  /* action */
  gst_object_sink (object);
  /* assertions */
  ASSERT (object->refcount == 1);
  ASSERT (GTK_OBJECT_FLOATING (object) == FALSE);
  /* cleanup */
  ENDTEST ();

  TEST ("increment refcount after sink");
  /* setup */
  /* action */
  gst_object_ref (object);
  /* assertions */
  ASSERT (object->refcount == 2);
  ASSERT (GTK_OBJECT_FLOATING (object) == FALSE);
  /* cleanup */
  ENDTEST ();

  TEST ("decrement refcount after sink");
  /* setup */
  /* action */
  gst_object_unref (object);
  /* assertions */
  ASSERT (object->refcount == 1);
  ASSERT (GTK_OBJECT_FLOATING (object) == FALSE);
  /* cleanup */
  ENDTEST ();

  /* category cleanup */
  g_free (object);



  /* new category */
  TEST_CATEGORY ("Parentage");
  /* category setup */
  object = gst_object_new ();
  parent = gst_object_new ();
  newparent = gst_object_new ();
  gtkobject = gtk_type_new (gtk_object_get_type ());
  /* category assertions */
  ASSERT (object != NULL);
  ASSERT (object->refcount == 1);
  ASSERT (object->parent == NULL);
  ASSERT (parent != NULL);
  ASSERT (newparent != NULL);
  ASSERT (gtkobject != NULL);
  ASSERT (!GST_IS_OBJECT (gtkobject));

  TEST ("gst_object_set_parent: null object");
  /* setup */
  /* action */
  gst_object_set_parent (NULL, NULL);
  /* assertions */
  ASSERT (object->parent == NULL);
  /* cleanup */
  ENDTEST ();

  TEST ("gst_object_set_parent: invalid object");
  /* setup */
  /* action */
  gst_object_set_parent ((GstObject *) gtkobject, NULL);
  /* assertions */
  ASSERT (object->parent == NULL);
  /* cleanup */
  ENDTEST ();

  TEST ("gst_object_set_parent: null parent");
  /* setup */
  /* action */
  gst_object_set_parent (object, NULL);
  /* assertions */
  ASSERT (object->parent == NULL);
  /* cleanup */
  ENDTEST ();

  TEST ("gst_object_set_parent: invalid parent");
  /* setup */
  /* action */
  gst_object_set_parent (object, (GstObject *) gtkobject);
  /* assertions */
  ASSERT (object->parent == NULL);
  /* cleanup */
  ENDTEST ();

  TEST ("gst_object_set_parent: valid object, parent is object");
  /* setup */
  /* action */
  gst_object_set_parent (object, object);
  /* assertions */
  ASSERT (object->parent == NULL);
  /* cleanup */
  ENDTEST ();

  TEST ("gst_object_set_parent: valid object and parent");
  /* setup */
  /* action */
  gst_object_set_parent (object, parent);
  /* assertions */
  ASSERT (object->parent == parent);
  /* cleanup */
  ENDTEST ();

  TEST ("gst_object_set_parent: parent already set");
  /* setup */
  /* action */
  gst_object_set_parent (object, newparent);
  /* assertions */
  ASSERT (object->parent != newparent);
  ASSERT (object->parent == parent);
  /* cleanup */
  g_free (object);
  ENDTEST ();


  TEST ("gst_object_get_parent: null object");
  /* setup */
  /* action */
  curparent = gst_object_get_parent (NULL);
  /* assertions */
  ASSERT (curparent == NULL);
  /* cleanup */
  ENDTEST ();

  TEST ("gst_object_get_parent: invalid object");
  /* setup */
  /* action */
  curparent = gst_object_get_parent ((GstObject *) gtkobject);
  /* assertions */
  ASSERT (curparent == NULL);
  /* cleanup */
  ENDTEST ();

  TEST ("gst_object_get_parent: no parent");
  /* setup */
  object = gst_object_new ();
  /* action */
  curparent = gst_object_get_parent (object);
  /* assertions */
  ASSERT (curparent == NULL);
  /* cleanup */
  ENDTEST ();

  TEST ("gst_object_get_parent: valid parent");
  /* setup */
  gst_object_set_parent (object, parent);
  /* action */
  curparent = gst_object_get_parent (object);
  /* assertions */
  ASSERT (curparent == parent);
  /* cleanup */
  g_free (object);
  ENDTEST ();


  TEST ("gst_object_unparent: null object");
  /* setup */
  /* action */
  gst_object_unparent (NULL);
  /* assertions */
  /* NONE - FIXME! */
  /* cleanup */
  ENDTEST ();

  TEST ("gst_object_unparent: invalid object");
  /* setup  */
  /* action */
  gst_object_unparent ((GstObject *) gtkobject);
  /* assertions */
  /* NONE - FIXME! */
  /* cleanup */
  ENDTEST ();

  TEST ("gst_object_unparent: no parent");
  /* setup */
  object = gst_object_new ();


  /* category cleanup */
  g_free (object);
  g_free (parent);
  g_free (newparent);
  g_free (gtkobject);



  fprintf (stderr, "\n\nTotal tests:\t%d\n", _total_tests);
  fprintf (stderr, "Total passed:\t%d\n", _passed_tests);
  fprintf (stderr, "Total FAILED:\t%d\n", _total_tests - _passed_tests);
}
