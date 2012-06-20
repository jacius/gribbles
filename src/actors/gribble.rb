
define_behavior :gribbly do
  requires :director
  
  setup do
    actor.has_attributes( color:         Color::WHITE,
                          radius:        10,
                          density:       20,
                          elasticity:    0.5,
                          friction:      0.8,
                          jitter_chance: 0.1)

    add_behavior( :physical,
                  shape:  :circle,
                  radius: actor.radius,
                  mass:   actor.density * actor.radius**2 * Math::PI,
                  elasticity: actor.elasticity,
                  friction:   actor.friction )

    actor.shape.layers = 1
    actor.body.v_limit = 2000

    director.when(:update) { |event| update(event) }

    @time_accum = 0
    reacts_with :jitter
  end

  helpers do
    def update(time_ms)
      @time_accum += time_ms
      while @time_accum > 1000
        if rand() < actor.jitter_chance
          actor.react_to :jitter
          @time_accum -= 1000
        else
          @time_accum -= 100 + rand(50)
        end
      end
    end

    def jitter
      angle = rand() * -Math::PI
      mag = actor.radius
      v = (CP::Vec2.for_angle(angle) + vec2(0, -0.5)) * mag
      actor.body.apply_impulse(v*actor.body.mass, CP::ZERO_VEC_2)
    end
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
