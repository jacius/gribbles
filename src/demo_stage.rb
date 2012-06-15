class DemoStage < Stage
  def setup
    super
    @physics_manager = this_object_context[:physics_manager]
    @physics_manager.configure
    @physics_manager.elastic_iterations = 4
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
end
