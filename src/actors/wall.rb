
define_behavior :wally do
  setup do
    actor.has_attributes( p1: nil,
                          p2: nil,
                          thickness: 0.5 )

    v1 = Ftor.new(*actor.p1)
    v2 = Ftor.new(*actor.p2)
    perp = (v2 - v1).normal.unit * actor.thickness

    verts = [(v1 + perp), (v2 + perp),
             (v2 - perp), (v1 - perp)].map(&:to_a)

    add_behavior( :physical,
                  shape:  :poly,
                  verts:  verts,
                  fixed:  true )
  end
end


define_actor :wall do
  has_behaviors :wally

  view do
    draw do |target, x_off, y_off, z|
      target.draw_line( actor.p1[0] + x_off, actor.p1[1] + y_off,
                        actor.p2[0] + x_off, actor.p2[1] + y_off,
                        Color::WHITE,
                        z )
    end
  end
end
