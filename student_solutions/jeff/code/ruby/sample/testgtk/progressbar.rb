=begin header

  progressbar.rb - a part of testgtk.c rewritten in ruby-gtk

  Rewritten by Minoru Inachi <inachi@earth.interq.or.jp>

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

class ProgressBarSample < SampleDialog

  def initialize
    super("Gtk::ProgressBar")
    set_policy(false, false, true)
    self.border_width = 10

    vbox1 = Gtk::VBox::new(false, 5)
    vbox1.border_width = 10
    self.vbox.pack_start(vbox1, false, true, 0)

    frame = Gtk::Frame::new("Progress")
    vbox1.pack_start(frame, false, true, 0)

    vbox2 = Gtk::VBox::new(false, 5)
    frame.add(vbox2)

    align = Gtk::Alignment::new(0.5, 0.5, 0, 0)
    vbox2.pack_start(align, FALSE, FALSE, 5)

    adj = Gtk::Adjustment::new(0, 1, 300, 0, 0, 0)
    adj.signal_connect("value_changed") do value_changed end

    @pbar = Gtk::ProgressBar::new(adj)
    @pbar.set_format_string("%v from [%l,%u] (=%p%%)")
    align.add(@pbar)
    @timer = Gtk::timeout_add(100) do progress_timeout end

    align = Gtk::Alignment::new(0.5, 0.5, 0, 0)
    vbox2.pack_start(align, false, false, 5);

    hbox = Gtk::HBox::new(false, 5)
    align.add(hbox)
    label = Gtk::Label::new("Label updated by user :")
    hbox.pack_start(label, false, true, 0)
    @label = Gtk::Label::new("")
    hbox.pack_start(@label, false, true, 0)

    frame = Gtk::Frame::new("Options")
    vbox1.pack_start(frame, false, true, 0)

    vbox2 = Gtk::VBox::new(false, 5)
    frame.add(vbox2)

    tab = Gtk::Table::new(7, 2, false)
    vbox2.pack_start(tab, false,true, 0)

    label = Gtk::Label::new("Orientation :");
    tab.attach(label, 0, 1, 0, 1,
	       Gtk::EXPAND | Gtk::FILL, Gtk::EXPAND | Gtk::FILL,
	       5, 5)
    label.set_alignment(0, 0.5)

    @omenu1 = build_option_menu(
	[ OptionMenuItem.new("Left-Right", proc { |w| toggle_orientation(w) }),
	  OptionMenuItem.new("Right-Left", proc { |w| toggle_orientation(w) }),
	  OptionMenuItem.new("Bottom-Top", proc { |w| toggle_orientation(w) }),
	  OptionMenuItem.new("Top-Bottom", proc { |w| toggle_orientation(w) })
	], 0)
    hbox = Gtk::HBox::new(false, 0)
    tab.attach(hbox, 1, 2, 0, 1,
		Gtk::EXPAND | Gtk::FILL, Gtk::EXPAND | Gtk::FILL,
		5, 5);
    hbox.pack_start(@omenu1)
       
    check = Gtk::CheckButton::new("Show text")
    check.signal_connect("clicked") do |w| toggle_show_text(w) end
    tab.attach(check, 0, 1, 1, 2,
		Gtk::EXPAND | Gtk::FILL, Gtk::EXPAND | Gtk::FILL,
		5, 5)

    hbox = Gtk::HBox::new(false, 0)
    tab.attach(hbox, 1, 2, 1, 2,
	       Gtk::EXPAND | Gtk::FILL, Gtk::EXPAND | Gtk::FILL,
	       5, 5)

    label = Gtk::Label::new("Format : ")
    hbox.pack_start(label, false, true, 0)

    @entry = Gtk::Entry::new()
    @entry.signal_connect("changed") do |w| entry_changed(w) end
    hbox.pack_start(@entry)
    @entry.set_text("%v from [%l,%u] (=%p%%)")
    @entry.set_usize(100, -1)
    @entry.set_sensitive(false)

    label = Gtk::Label::new("Text align :")
    tab.attach(label, 0, 1, 2, 3,
 		Gtk::EXPAND | Gtk::FILL, Gtk::EXPAND | Gtk::FILL,
		5, 5)
    label.set_alignment(0, 0.5)

    hbox = Gtk::HBox::new(false, 0)
    tab.attach(hbox, 1, 2, 2, 3,
		Gtk::EXPAND | Gtk::FILL, Gtk::EXPAND | Gtk::FILL,
		5, 5)

    label = Gtk::Label::new("x :")
    hbox.pack_start(label, false, true, 5)
      
    adj = Gtk::Adjustment::new(0.5, 0, 1, 0.1, 0.1, 0)
    @x_align_spin = Gtk::SpinButton::new(adj, 0, 1)
    adj.signal_connect("value_changed") do adjust_align end
    hbox.pack_start(@x_align_spin, false, true, 0)
    @x_align_spin.set_sensitive(false)

    label = Gtk::Label::new("y :")
    hbox.pack_start(label, false, true, 5)

    adj = Gtk::Adjustment::new(0.5, 0, 1, 0.1, 0.1, 0)
    @y_align_spin = Gtk::SpinButton::new(adj, 0, 1)
    adj.signal_connect("value_changed") do adjust_align end
    hbox.pack_start(@y_align_spin, false, true, 0)
    @y_align_spin.set_sensitive(false)

    label = Gtk::Label::new("Bar Style :")
    tab.attach(label, 0, 1, 3, 4,
		Gtk::EXPAND | Gtk::FILL, Gtk::EXPAND | Gtk::FILL,
		5, 5);
    label.set_alignment(0, 0.5)

    @omenu2 = build_option_menu(
	[ OptionMenuItem.new("Continuous", proc { |w| toggle_bar_style(w) }),
	  OptionMenuItem.new("Discrete", proc { |w| toggle_bar_style(w) }),
	], 0)
    hbox = Gtk::HBox::new(false, 0)
    tab.attach(hbox, 1, 2, 3, 4,
		Gtk::EXPAND | Gtk::FILL, Gtk::EXPAND | Gtk::FILL,
		5, 5);
    hbox.pack_start(@omenu2)

    label = Gtk::Label::new("Block count :")
    tab.attach(label, 0, 1, 4, 5,
		Gtk::EXPAND | Gtk::FILL, Gtk::EXPAND | Gtk::FILL,
		5, 5)
    label.set_alignment(0, 0.5)

    hbox = Gtk::HBox::new(false, 0)
    tab.attach(hbox, 1, 2, 4, 5,
		Gtk::EXPAND | Gtk::FILL, Gtk::EXPAND | Gtk::FILL,
		5, 5)
    adj = Gtk::Adjustment::new(10, 2, 20, 1, 5, 0)
    @block_spin = Gtk::SpinButton::new(adj, 0, 0)
    adj.signal_connect("value_changed") do adjust_blocks end
    hbox.pack_start(@block_spin, false, true, 0)
    @block_spin.set_sensitive(false)

    check = Gtk::CheckButton::new("Activity mode")
    check.signal_connect("clicked") do |w| toggle_activity_mode(w) end
    tab.attach(check, 0, 1, 5, 6,
		Gtk::EXPAND | Gtk::FILL, Gtk::EXPAND | Gtk::FILL,
		5, 5);

    hbox = Gtk::HBox::new(false, 0)
    tab.attach(hbox, 1, 2, 5, 6,
		Gtk::EXPAND | Gtk::FILL, Gtk::EXPAND | Gtk::FILL,
		5, 5)
    label = Gtk::Label::new("Step size : ")
    hbox.pack_start(label, false, true, 0)
    adj = Gtk::Adjustment::new(3, 1, 20, 1, 5, 0)
    @step_spin = Gtk::SpinButton::new(adj, 0, 0)
    adj.signal_connect("value_changed") do adjust_step end
    hbox.pack_start(@step_spin, false, true, 0)
    @step_spin.set_sensitive(false)

    hbox = Gtk::HBox::new(false, 0)
    tab.attach(hbox, 1, 2, 6, 7,
		Gtk::EXPAND | Gtk::FILL, Gtk::EXPAND | Gtk::FILL,
		5, 5)
    label = Gtk::Label::new("Blocks :     ")
    hbox.pack_start(label, false, true, 0)
    adj = Gtk::Adjustment::new(5, 2, 10, 1, 5, 0)
    @act_blocks_spin = Gtk::SpinButton::new(adj, 0, 0)
    adj.signal_connect("value_changed") do adjust_act_blocks end
    hbox.pack_start(@act_blocks_spin, false, true, 0)
    @act_blocks_spin.set_sensitive(false)

    button = Gtk::Button::new("close")
    button.signal_connect("clicked") do
      Gtk::timeout_remove(@timer)
      destroy
    end
    button.flags |= Gtk::Widget::CAN_DEFAULT
    self.action_area.pack_start(button)
    button.grab_default
  end

  private
  def toggle_orientation(rmitem)
    return unless rmitem.mapped?

    i = 3
    group = rmitem.group
    group.each do |g|
      break if g.active?
      i -= 1
    end

    @pbar.set_orientation(i)
  end

  private
  def toggle_bar_style(rmitem)
    return unless rmitem.mapped?

    i = 1
    group = rmitem.group
    group.each do |g|
      break if g.active?
      i -= 1
    end

    if i == 1 then
      @block_spin.set_sensitive(true)
    else
      @block_spin.set_sensitive(false)
    end

    @pbar.set_bar_style(i)
  end

  private
  def progress_timeout
    adj = @pbar.adjustment

    new_val = adj.value + 1
    new_val = adj.lower if new_val > adj.upper

    @pbar.set_value(new_val)

    true
  end

  private
  def value_changed
    if @pbar.activity_mode? then
      buf = sprintf("???");
    else
      #buf = sprintf("%.0f%%", 100 *  @pbar.get_current_percentage)
      buf = sprintf("%d%%", 100 *  @pbar.get_current_percentage)
    end
    @label.set_text(buf)
  end

  private
  def toggle_show_text(cbutton)
    @pbar.set_show_text(cbutton.active?)
    @entry.set_sensitive(cbutton.active?)
    @x_align_spin.set_sensitive(cbutton.active?)
    @y_align_spin.set_sensitive(cbutton.active?)
  end

  private
  def entry_changed(entry)
    @pbar.set_format_string(entry.get_text)
  end

  private
  def adjust_align
    @pbar.set_text_alignment(
	@x_align_spin.get_value_as_float,
	@y_align_spin.get_value_as_float)
  end

  private
  def adjust_blocks
    @pbar.set_percentage(0)
    @pbar.set_discrete_blocks(@block_spin.get_value_as_int)
  end

  private
  def adjust_step
    @pbar.set_activity_step(@step_spin.get_value_as_int)
  end

  private
  def adjust_act_blocks
    @pbar.set_activity_blocks(@act_blocks_spin.get_value_as_int)
  end

  private
  def toggle_activity_mode(cbutton)
    @pbar.set_activity_mode(cbutton.active?)
    @step_spin.set_sensitive(cbutton.active?)
    @act_blocks_spin.set_sensitive(cbutton.active?)
  end
end
