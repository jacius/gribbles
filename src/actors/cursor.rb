
define_behavior :grabby do
  requires :input_manager
  setup do
    actor.has_attributes( target: nil )
    reacts_with :grab, :ungrab, :move_to

    input_manager.reg :mouse_motion do |event|
      x,y = event[:data]
      actor.react_to :move_to, x, y
    end
  end

  helpers do
    def grab(target)
      return actor.ungrab() if target.nil?
      actor.target = target
      actor.target.react_to :grabbed, actor
    end

    def ungrab
      actor.target.react_to :ungrabbed if actor.target
      actor.target = nil
    end

    def move_to(x,y)
      actor.x, actor.y = x,y
    end
  end
  
end

define_actor :cursor do
  has_behaviors :visible, :positioned, :grabby

  view do
    draw do |target, x_off, y_off, z|
      x = actor.x + x_off
      y = actor.y + y_off
      size = 4
      color = actor.target ? Color::GREEN : Color::RED

      if actor.target
        x2 = actor.target.x + x_off
        y2 = actor.target.y + y_off
        target.draw_line( x, y, x2, y2, Color::YELLOW, actor.z )
      end

      target.draw_circle_filled( x, y, size, color, actor.z )
    end
  end
end
