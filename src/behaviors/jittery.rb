
define_behavior :jittery do
  requires :director
  
  setup do
    actor.has_attributes( jitter_chance: 0.1 )
    reacts_with :jitter
    @time_accum = 0
    director.when(:update) { |event| update(event) }
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
