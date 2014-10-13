
#include <stdio.h>
#include <math.h>
#include <glib.h>

static int
get_value (int i)
{
  int x;

  x = floor (256 * (0.5 + 0.5 * sin (i * 2 * G_PI / 256)));
  if (x > 255)
    x = 255;
  return x;
}

int
main (int argc, char *argv[])
{
  int i;
  int j;

  printf ("static const guint8\n");
  printf ("sine_table[256] = {\n");
  for (i = 0; i < 256; i += 8) {
    printf ("  ");
    for (j = 0; j < 8; j++) {
      printf ("%3d", get_value (i + j));
      if (j != 7) {
        printf (", ");
      } else {
        if (i + j != 255) {
          printf (",\n");
        } else {
          printf ("\n");
        }
      }
    }
  }
  printf ("};\n");

  return 0;
}
