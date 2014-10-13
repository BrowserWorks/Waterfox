/* GStreamer
 * Copyright (C) 2009 Edward Hervey <bilboed@bilboed.com>
 *
 * gstqueuearray.c:
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

/**
 * SECTION:gstqueuearray
 * @short_description: Array based queue object
 *
 * #GstQueueArray is an object that provides standard queue functionality
 * based on an array instead of linked lists. This reduces the overhead
 * caused by memory management by a large factor.
 */


#include <string.h>
#include <gst/gst.h>
#include "gstqueuearray.h"

struct _GstQueueArray
{
  /* < private > */
  gpointer *array;
  guint size;
  guint head;
  guint tail;
  guint length;
};

/**
 * gst_queue_array_new: (skip)
 * @initial_size: Initial size of the new queue
 *
 * Allocates a new #GstQueueArray object with an initial
 * queue size of @initial_size.
 *
 * Returns: a new #GstQueueArray object
 *
 * Since: 1.2
 */
GstQueueArray *
gst_queue_array_new (guint initial_size)
{
  GstQueueArray *array;

  array = g_slice_new (GstQueueArray);
  array->size = initial_size;
  array->array = g_new0 (gpointer, initial_size);
  array->head = 0;
  array->tail = 0;
  array->length = 0;
  return array;
}


/**
 * gst_queue_array_free: (skip)
 * @array: a #GstQueueArray object
 *
 * Frees queue @array and all memory associated to it.
 *
 * Since: 1.2
 */
void
gst_queue_array_free (GstQueueArray * array)
{
  g_free (array->array);
  g_slice_free (GstQueueArray, array);
}

/**
 * gst_queue_array_pop_head: (skip)
 * @array: a #GstQueueArray object
 *
 * Returns and head of the queue @array and removes
 * it from the queue.
 *
 * Returns: The head of the queue
 *
 * Since: 1.2
 */
gpointer
gst_queue_array_pop_head (GstQueueArray * array)
{
  gpointer ret;

  /* empty array */
  if (G_UNLIKELY (array->length == 0))
    return NULL;
  ret = array->array[array->head];
  array->head++;
  array->head %= array->size;
  array->length--;
  return ret;
}

/**
 * gst_queue_array_peek_head: (skip)
 * @array: a #GstQueueArray object
 *
 * Returns and head of the queue @array and does not
 * remove it from the queue.
 *
 * Returns: The head of the queue
 *
 * Since: 1.2
 */
gpointer
gst_queue_array_peek_head (GstQueueArray * array)
{
  /* empty array */
  if (G_UNLIKELY (array->length == 0))
    return NULL;
  return array->array[array->head];
}

/**
 * gst_queue_array_push_tail: (skip)
 * @array: a #GstQueueArray object
 * @data: object to push
 *
 * Pushes @data to the tail of the queue @array.
 *
 * Since: 1.2
 */
void
gst_queue_array_push_tail (GstQueueArray * array, gpointer data)
{
  /* Check if we need to make room */
  if (G_UNLIKELY (array->length == array->size)) {
    /* newsize is 50% bigger */
    guint newsize = MAX ((3 * array->size) / 2, array->size + 1);

    /* copy over data */
    if (array->tail != 0) {
      gpointer *array2 = g_new0 (gpointer, newsize);
      guint t1 = array->head;
      guint t2 = array->size - array->head;

      /* [0-----TAIL][HEAD------SIZE]
       *
       * We want to end up with
       * [HEAD------------------TAIL][----FREEDATA------NEWSIZE]
       *
       * 1) move [HEAD-----SIZE] part to beginning of new array
       * 2) move [0-------TAIL] part new array, after previous part
       */

      memcpy (array2, &array->array[array->head], t2 * sizeof (gpointer));
      memcpy (&array2[t2], array->array, t1 * sizeof (gpointer));

      g_free (array->array);
      array->array = array2;
      array->head = 0;
    } else {
      /* Fast path, we just need to grow the array */
      array->array = g_renew (gpointer, array->array, newsize);
    }
    array->tail = array->size;
    array->size = newsize;
  }

  array->array[array->tail] = data;
  array->tail++;
  array->tail %= array->size;
  array->length++;
}

/**
 * gst_queue_array_is_empty: (skip)
 * @array: a #GstQueueArray object
 *
 * Checks if the queue @array is empty.
 *
 * Returns: %TRUE if the queue @array is empty
 *
 * Since: 1.2
 */
gboolean
gst_queue_array_is_empty (GstQueueArray * array)
{
  return (array->length == 0);
}

/**
 * gst_queue_array_drop_element: (skip)
 * @array: a #GstQueueArray object
 * @idx: index to drop
 *
 * Drops the queue element at position @idx from queue @array.
 *
 * Returns: the dropped element
 *
 * Since: 1.2
 */
gpointer
gst_queue_array_drop_element (GstQueueArray * array, guint idx)
{
  int first_item_index, last_item_index;
  gpointer element;

  g_return_val_if_fail (array->length > 0, NULL);
  g_return_val_if_fail (idx < array->size, NULL);

  first_item_index = array->head;

  /* tail points to the first free spot */
  last_item_index = (array->tail - 1 + array->size) % array->size;

  element = array->array[idx];

  /* simple case idx == first item */
  if (idx == first_item_index) {
    /* move the head plus one */
    array->head++;
    array->head %= array->size;
    array->length--;
    return element;
  }

  /* simple case idx == last item */
  if (idx == last_item_index) {
    /* move tail minus one, potentially wrapping */
    array->tail = (array->tail - 1 + array->size) % array->size;
    array->length--;
    return element;
  }

  /* non-wrapped case */
  if (first_item_index < last_item_index) {
    g_assert (first_item_index < idx && idx < last_item_index);
    /* move everything beyond idx one step towards zero in array */
    memmove (&array->array[idx],
        &array->array[idx + 1], (last_item_index - idx) * sizeof (gpointer));
    /* tail might wrap, ie if tail == 0 (and last_item_index == size) */
    array->tail = (array->tail - 1 + array->size) % array->size;
    array->length--;
    return element;
  }

  /* only wrapped cases left */
  g_assert (first_item_index > last_item_index);

  if (idx < last_item_index) {
    /* idx is before last_item_index, move data towards zero */
    memmove (&array->array[idx],
        &array->array[idx + 1], (last_item_index - idx) * sizeof (gpointer));
    /* tail should not wrap in this case! */
    g_assert (array->tail > 0);
    array->tail--;
    array->length--;
    return element;
  }

  if (idx > first_item_index) {
    element = array->array[idx];
    /* idx is after first_item_index, move data to higher indices */
    memmove (&array->array[first_item_index + 1],
        &array->array[first_item_index],
        (idx - first_item_index) * sizeof (gpointer));
    array->head++;
    /* head should not wrap in this case! */
    g_assert (array->head < array->size);
    array->length--;
    return element;
  }

  g_return_val_if_reached (NULL);
}

/**
 * gst_queue_array_find: (skip)
 * @array: a #GstQueueArray object
 * @func: (allow-none): comparison function, or %NULL to find @data by value
 * @data: data for comparison function
 *
 * Finds an element in the queue @array, either by comparing every element
 * with @func or by looking up @data if no compare function @func is provided,
 * and returning the index of the found element.
 *
 * Note that the index is not 0-based, but an internal index number with a
 * random offset. The index can be used in connection with
 * gst_queue_array_drop_element(). FIXME: return index 0-based and make
 * gst_queue_array_drop_element() take a 0-based index.
 *
 * Returns: Index of the found element or -1 if nothing was found.
 *
 * Since: 1.2
 */
guint
gst_queue_array_find (GstQueueArray * array, GCompareFunc func, gpointer data)
{
  guint i;

  if (func != NULL) {
    /* Scan from head to tail */
    for (i = 0; i < array->length; i++) {
      if (func (array->array[(i + array->head) % array->size], data) == 0)
        return (i + array->head) % array->size;
    }
  } else {
    for (i = 0; i < array->length; i++) {
      if (array->array[(i + array->head) % array->size] == data)
        return (i + array->head) % array->size;
    }
  }

  return -1;
}

/**
 * gst_queue_array_get_length: (skip)
 * @array: a #GstQueueArray object
 *
 * Returns the length of the queue @array
 *
 * Returns: the length of the queue @array.
 *
 * Since: 1.2
 */
guint
gst_queue_array_get_length (GstQueueArray * array)
{
  return array->length;
}
