
# This behavior allows a physical actor to be "grabbed" by another
# actor. While grabbed, this actor will "slew" (move) to be as close
# as possible to the grabber's position at all times. Also, the
# grabbed actor's gravity is temporarily cancelled out (to stop it
# falling) and its moment of inertia increased (to stop it spinning).
# 
# After adding this behavior to an actor, send it the :grabbed event
# to tell it that is has been grabbed by another actor, or the
# :ungrabbed event to tell it that it has been ungrabbed (released).
# 
define_behavior :grabbable do
  requires :physics_manager, :director

  setup do
    actor.has_attributes( grabbed_by: nil )

    @old_angle = actor.body.a
    @old_moment = actor.body.moment

    @physman = physics_manager

    director.when :update do |time_ms|
      update(time_ms)
    end

    reacts_with :grabbed, :ungrabbed
  end

  helpers do
    def update(time_ms)
      if actor.grabbed_by
        time_s = time_ms/1000.0
        # Move towards the grabber.
        actor.body.slew(vec2(actor.grabbed_by.x,
                             actor.grabbed_by.y),
                        time_s)
      end
    end

    def grabbed(grabbed_by)
      actor.grabbed_by = grabbed_by

      body = actor.body

      # Cancel out gravity on this body, so it won't fall.
      body.apply_force(-@physman.gravity * body.mass, CP::ZERO_VEC_2)

      # Stop current velocity and rotation.
      body.v = CP::ZERO_VEC_2
      body.w = 0

      # Increase moment of inertia, so actor won't spin while grabbed.
      @old_moment = body.moment
      body.moment = Float::INFINITY
    end

    def ungrabbed
      actor.grabbed_by = nil
      # Stop cancelling gravity.
      actor.body.reset_forces
      # Reset moment of inertia.
      actor.body.moment = @old_moment
    end
  end
end
