
define_behavior :wally do
  setup do
    actor.has_attributes( p1: nil,
                          p2: nil,
                          thickness:  2,
                          elasticity: 0.5,
                          friction:   0.2)

    add_behavior( :physical,
                  shape:      :segment,
                  endpoints:  [actor.p1, actor.p2],
                  radius:     actor.thickness,
                  fixed:      true,
                  elasticity: actor.elasticity,
                  friction:   actor.friction )

    actor.shape.layers = 1
  end
end


define_actor :wall do
  has_behaviors :wally, :visible

  view do
    draw do |target, x_off, y_off, z|
      target.draw_line( actor.p1[0] + x_off, actor.p1[1] + y_off,
                        actor.p2[0] + x_off, actor.p2[1] + y_off,
                        Color::WHITE,
                        z )
    end
  end
end
