define_behavior :follows_mouse do
  requires :input_manager

  setup do
    input_manager.reg :mouse_motion do |event|
      actor.x, actor.y = event[:data]
    end
  end
end
