/*
 * Copyright © 2011 Canonical Limited
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the licence, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Author: Ryan Lortie <desrt@desrt.ca>
 */

#ifndef __G_WAKEUP_H__
#define __G_WAKEUP_H__

#include <glib/gpoll.h>

typedef struct _GWakeup GWakeup;

GWakeup *       g_wakeup_new            (void);
void            g_wakeup_free           (GWakeup *wakeup);

void            g_wakeup_get_pollfd     (GWakeup *wakeup,
                                         GPollFD *poll_fd);
void            g_wakeup_signal         (GWakeup *wakeup);
void            g_wakeup_acknowledge    (GWakeup *wakeup);

#endif
