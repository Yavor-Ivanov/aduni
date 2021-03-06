=begin header

  idle.rb - a part of testgtk.c rewritten in ruby-gtk

  Rewritten by Hiroshi IGARASHI <igarashi@ueda.info.waseda.ac.jp>
  $Date: 2000/01/29 09:58:32 $
  $Id: idle.rb,v 1.2 2000/01/29 09:58:32 iga Exp $

Original Copyright:
 
  GTK - The GIMP Toolkit
  Copyright (C) 1995-1997 Peter Mattis, Spencer Kimball and Josh MacDonald
 
  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Library General Public
  License as published by the Free Software Foundation; either
  version 2 of the License, or (at your option) any later version.
 
  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Library General Public License for more details.
 
  You should have received a copy of the GNU Library General Public
  License along with this library; if not, write to the
  Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  Boston, MA 02111-1307, USA.

=end

require 'sample'

# #
# # Idle Test
# #
# static int idle = 0

# gint
# idle_test (GtkWidget *label)
#   static int count = 0
#   static char buffer[32]

#   sprintf (buffer, "count: %d", ++count)
#   label.set(buffer)

#   return true
# end

# void
# start_idle_test (GtkWidget *widget,
# 		 GtkWidget *label)
#   if (!idle)
#     {
#       idle = gtk_idle_add ((GtkFunction) idle_test, label)
#     }
# end

# void
# stop_idle_test (GtkWidget *widget,
# 		gpointer   data)
#   if (idle)
#     {
#       gtk_idle_remove (idle)
#       idle = 0
#     }
# end

# void
# destroy_idle_test (GtkWidget  *widget,
# 		   GtkWidget **window)
#   stop_idle_test (nil, nil)

#   window = nil
# end

# void
# create_idle_test ()
#   static GtkWidget *window = nil
#   GtkWidget *button
#   GtkWidget *label

#   if (!window)
#     {
#       window = Gtk::Dialog::new()

#       window.signal_connect("destroy",
# 			  destroy_idle_test,
# 			  window)

#       window.set_title("Idle Test")
#       window.border_width(0)

#       label = Gtk::Label::new("count: 0")
#       label.set_padding(10, 10)
#       gtk_box_pack_start (window.vbox, 
# 			  label, true, true, 0)
#       label.show

#       button = Gtk::Button::new("close")
#       gtk_signal_connect_object (button, "clicked",
# 				 gtk_widget_destroy,
# 				 window)
#       button.set_flags(Gtk::Widget::CAN_DEFAULT)
#       gtk_box_pack_start (window.action_area, 
# 			  button, true, true, 0)
#       button.grab_default
#       button.show

#       button = Gtk::Button::new("start")
#       button.signal_connect("clicked",
# 			  start_idle_test,
# 			  label)
#       button.set_flags(Gtk::Widget::CAN_DEFAULT)
#       gtk_box_pack_start (window.action_area, 
# 			  button, true, true, 0)
#       button.show

#       button = Gtk::Button::new("stop")
#       button.signal_connect("clicked",
# 			  stop_idle_test,
# 			  nil)
#       button.set_flags(Gtk::Widget::CAN_DEFAULT)
#       gtk_box_pack_start (window.action_area, 
# 			  button, true, true, 0)
#       button.show
#     }

#   if (!window.visible?)
#     window.show
#   else
#     window.destroy
# end
