class DemoStage < Stage
  attr_accessor :physics_manager

  def setup
    super
    @physics_manager = this_object_context[:physics_manager]
    @physics_manager.configure
    @physics_manager.space.gravity = vec2(0, 400)
    @physics_manager.damping = 0.4

    @gribble = spawn( :gribble,
                      x: 30, y: 30,
                      color: Color::RED,
                      radius: 20 )

    @wall_top = spawn( :wall,
                       p1: [0,    0],
                       p2: [1024, 0] )

    @wall_bottom = spawn( :wall,
                          p1: [0,    799],
                          p2: [1024, 799] )

    @wall_left = spawn( :wall,
                          p1: [1,   0],
                          p2: [1, 799] )

    @wall_right = spawn( :wall,
                          p1: [1024,   0],
                          p2: [1024, 799] )
  end

  def update(time)
    super
    @physics_manager.update_physics(time)
  end

end
