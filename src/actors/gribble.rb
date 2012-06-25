
define_behavior :gribbly do
  setup do
    actor.has_attributes( color: Color::WHITE ) 
    actor.shape.layers = 1
    actor.body.v_limit = 2000
  end
end


define_actor :gribble do
  has_behaviors :bally, :grabbable, :jittery, :gribbly
  view do
    draw do |target, x_off, y_off, z|
      x = actor.x + x_off
      y = actor.y + y_off
      
      target.draw_circle_filled( x, y, actor.radius, actor.color, z )

      angle = actor.body.rot * actor.radius
      target.draw_line( x, y, x + angle.x, y + angle.y,
                        Color::BLACK, z )
    end
  end
end
