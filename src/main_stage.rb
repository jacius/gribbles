class MainStage < Stage
  attr_accessor :physics_manager

  def setup
    super
    @physics_manager = this_object_context[:physics_manager]
    @physics_manager.configure
    @physics_manager.space.gravity = vec2(0, 400)
    @physics_manager.damping = 0.4

    @gribbles = []
    @grabber = spawn :grabber, z: 100

    width, height = 800, 600
    thick = 20
    topleft  = [0     - thick, 0      - thick]
    topright = [width + thick, 0      - thick]
    botleft  = [0     - thick, height + thick]
    botright = [width + thick, height + thick]

    @wall_top = spawn( :wall, p1: topleft, p2: topright,
                       thickness: thick )
    @wall_top.react_to :hide

    @wall_bottom = spawn( :wall, p1: botleft, p2: botright,
                          thickness: thick )
    @wall_bottom.react_to :hide

    @wall_left = spawn( :wall, p1: topleft, p2: botleft,
                        thickness: thick )
    @wall_left.react_to :hide

    @wall_right = spawn( :wall, p1: topright, p2: botright,
                         thickness: thick )
    @wall_right.react_to :hide


    @input_man = this_object_context[:input_manager]

    @input_man.reg :mouse_down, MsLeft do |event|
      left_click(event)
    end

    @input_man.reg :mouse_up, MsLeft do |event|
      left_unclick(event)
    end
  end

  def left_click(event)
    x,y = event[:data].map(&:to_i)
    clicked_on = find_gribble_at(x,y)
    if clicked_on
      @grabber.react_to :grab, clicked_on
    else
      # Clicked on empty space, so create a new random gribble
      @gribbles << make_random_gribble(x,y)
    end
  end

  def left_unclick(event)
    @grabber.react_to :ungrab
  end

  def find_gribble_at(x, y)
    v = vec2(x,y)
    # TODO: do a space point query first, to narrow the possibilities?
    @gribbles.find { |gribble| gribble.shape.point_query(v) }
  end

  def make_random_gribble(x, y)
    spawn( :gribble,
           x: x, y: y,
           color: Color.rgb(50 + rand(200),
                            50 + rand(200),
                            50 + rand(200)),
           radius: 10 + rand(20) )
  end

  def update(time)
    super
    @physics_manager.update_physics(time)
  end

end
