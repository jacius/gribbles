
define_behavior :grabby do
  requires :physics_manager, :input_manager
  setup do
    actor.has_attributes( target: nil )
    reacts_with :grab, :ungrab, :move
    
    i = input_manager
    i.reg :mouse_motion do |event|
      x,y = event[:data]
      move(x,y)
    end

    @constraint = nil
    actor.shape.layers = 2
  end

  helpers do
    def grab(target)
      return actor.ungrab() if target.nil? 
      actor.target = target

      rest_length = 0
      stiffness = 10000000
      damping = 20000
      @constraint =
        CP::Constraint::DampedSpring.new( actor.body, target.body,
                                          CP::ZERO_VEC_2, CP::ZERO_VEC_2,
                                          rest_length, stiffness, damping )
      actor.constraints << @constraint
      actor.target.constraints << @constraint
      actor.target.body.
        apply_force(-physics_manager.gravity * actor.target.body.mass,
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

    def move(x,y)
      actor.react_to :warp, vec2(x,y)
    end
  end
  
end

define_actor :grabber do
  has_behavior( physical: {
                  shape:  :circle,
                  radius: 1,
                  fixed:  true,
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
