
define_behavior :grabby do
  requires :physics_manager, :input_manager, :director
  setup do
    actor.has_attributes( target: nil,
                          goal_pos: vec2(0,0) )

    reacts_with :grab, :ungrab, :move_to
    
    i = input_manager
    i.reg :mouse_motion do |event|
      x,y = event[:data]
      actor.goal_pos = vec2(x,y)
    end

    director.when :update do |time_ms|
      update(time_ms)
    end

    @constraint = nil
    actor.shape.layers = 2

    actor.body.
      apply_force(-physics_manager.gravity * actor.body.mass,
                  CP::ZERO_VEC_2)
  end

  helpers do
    def grab(target)
      unless target
        return actor.ungrab()
      end

      actor.target = target
      actor.react_to :warp, target.body.p
      @constraint =
        CP::Constraint::PinJoint.new( actor.body, target.body,
                                      CP::ZERO_VEC_2, CP::ZERO_VEC_2 )
      actor.constraints << @constraint
      target.constraints << @constraint
      target.body.
        apply_force(-physics_manager.gravity * target.body.mass,
                    CP::ZERO_VEC_2)
      physics_manager.register_physical_constraint(@constraint)
    end

    def ungrab
      physics_manager.unregister_physical_constraint(@constraint)
      actor.constraints = []
      if actor.target
        actor.target.constraints = []
        actor.target.body.reset_forces
      end
      @constraint = nil
      actor.target = nil
    end

    def update(time_ms)
      if actor.target
        actor.body.slew(actor.goal_pos, time_ms/1000.0)
      else
        actor.react_to :warp, actor.goal_pos
      end
    end
  end
  
end


define_actor :grabber do
  has_behavior( physical: {
                  shape:  :circle,
                  radius: 1,
                  # fixed:  true,
                  mass:   1e6,
                  layer:  2 } )
  has_behavior :grabby
  has_behavior :visible

  view do
    draw do |target, x_off, y_off, z|
      x = actor.x + x_off
      y = actor.y + y_off
      size = 4
      color = actor.target ? Color::GREEN : Color::RED

      if actor.target
        x2 = actor.target.body.p.x + x_off
        y2 = actor.target.body.p.y + y_off
        target.draw_line( x, y, x2, y2, Color::YELLOW, actor.z )
      end

      target.draw_circle_filled( x, y, size, color, actor.z )
    end
  end
end
