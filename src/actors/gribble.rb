
define_behavior :gribbly do
  setup do
    actor.has_attributes( color:  (opts[:color]  || Color::WHITE),
                          radius: (opts[:radius] || 10) )
  end
end


define_actor :gribble do
  has_behavior :positioned, :gribbly
  view do
    draw do |target, x_off, y_off, z|
      target.draw_circle_filled( actor.x + x_off, actor.y + y_off,
                                 actor.radius, actor.color,
                                 z )
    end
  end
end
