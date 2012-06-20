
define_behavior :gribbly do
  setup do
    actor.has_attributes( color:   Color::WHITE,
                          radius:  10,
                          density: 20,
                          elasticity: 0.5,
                          friction:   0.8 )

    add_behavior( :physical,
                  shape:  :circle,
                  radius: actor.radius,
                  mass:   actor.density * actor.radius**2 * Math::PI,
                  elasticity: actor.elasticity,
                  friction:   actor.friction )

    actor.shape.layers = 1
    actor.body.v_limit = 2000
  end
end


define_actor :gribble do
  has_behaviors :gribbly, :grabbable
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
