
define_actor :cursor do
  has_behaviors :visible, :positioned, :follows_mouse, :grabber

  view do
    draw do |target, x_off, y_off, z|
      x = actor.x + x_off
      y = actor.y + y_off
      size = 4
      color = actor.grab_target ? Color::GREEN : Color::RED

      if actor.grab_target
        x2 = actor.grab_target.x + x_off
        y2 = actor.grab_target.y + y_off
        target.draw_line( x, y, x2, y2, Color::YELLOW, actor.z )
      end

      target.draw_circle_filled( x, y, size, color, actor.z )
    end
  end
end
