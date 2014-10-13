/*
 * Check: a unit test framework for C
 * Copyright (C) 2001, 2002 Arien Malec
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#include "config.h"

#include <stdlib.h>
#include <string.h>

#include "check_list.h"
#include "check_error.h"


enum
{
  LINIT = 1,
  LGROW = 2
};

struct List
{
  int n_elts;
  int max_elts;
  int current;                  /* pointer to the current node */
  int last;                     /* pointer to the node before END */
  const void **data;
};

static void
maybe_grow (List * lp)
{
  if (lp->n_elts >= lp->max_elts) {
    lp->max_elts *= LGROW;
    lp->data = erealloc (lp->data, lp->max_elts * sizeof (lp->data[0]));
  }
}

List *
check_list_create (void)
{
  List *lp;
  lp = emalloc (sizeof (List));
  lp->n_elts = 0;
  lp->max_elts = LINIT;
  lp->data = emalloc (sizeof (lp->data[0]) * LINIT);
  lp->current = lp->last = -1;
  return lp;
}

void
list_add_front (List * lp, const void *val)
{
  if (lp == NULL)
    return;
  maybe_grow (lp);
  memmove (lp->data + 1, lp->data, lp->n_elts * sizeof lp->data[0]);
  lp->last++;
  lp->n_elts++;
  lp->current = 0;
  lp->data[lp->current] = val;
}

void
list_add_end (List * lp, const void *val)
{
  if (lp == NULL)
    return;
  maybe_grow (lp);
  lp->last++;
  lp->n_elts++;
  lp->current = lp->last;
  lp->data[lp->current] = val;
}

int
list_at_end (List * lp)
{
  if (lp->current == -1)
    return 1;
  else
    return (lp->current > lp->last);
}

void
list_front (List * lp)
{
  if (lp->current == -1)
    return;
  lp->current = 0;
}


void
list_free (List * lp)
{
  if (lp == NULL)
    return;

  free (lp->data);
  free (lp);
}

void *
list_val (List * lp)
{
  if (lp == NULL)
    return NULL;
  if (lp->current == -1 || lp->current > lp->last)
    return NULL;

  return (void *) lp->data[lp->current];
}

void
list_advance (List * lp)
{
  if (lp == NULL)
    return;
  if (list_at_end (lp))
    return;
  lp->current++;
}


void
list_apply (List * lp, void (*fp) (void *))
{
  if (lp == NULL || fp == NULL)
    return;

  for (list_front (lp); !list_at_end (lp); list_advance (lp))
    fp (list_val (lp));

}
