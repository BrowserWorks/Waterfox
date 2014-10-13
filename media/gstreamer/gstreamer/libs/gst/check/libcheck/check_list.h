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

#ifndef CHECK_LIST_H
#define CHECK_LIST_H

typedef struct List List;

/* Create an empty list */
List * check_list_create (void);

/* Is list at end? */
int list_at_end (List * lp);

/* Position list at front */
void list_front(List *lp);

/* Add a value to the front of the list,
   positioning newly added value as current value.
   More expensive than list_add_end, as it uses memmove. */
void list_add_front (List *lp, const void *val);

/* Add a value to the end of the list,
   positioning newly added value as current value */
void list_add_end (List *lp, const void *val);

/* Give the value of the current node */
void *list_val (List * lp);

/* Position the list at the next node */
void list_advance (List * lp);

/* Free a list, but don't free values */
void list_free (List * lp);

void list_apply (List *lp, void (*fp) (void *));


#endif /* CHECK_LIST_H */
