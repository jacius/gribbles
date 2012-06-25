
define_behavior :grabber do
  setup do
    actor.has_attributes( grab_target: nil )
    reacts_with :grab, :ungrab
  end

  helpers do
    def grab(grab_target)
      return actor.ungrab() if grab_target.nil?
      actor.grab_target = grab_target
      actor.grab_target.react_to :grabbed_by, actor
    end

    def ungrab
      actor.grab_target.react_to :ungrabbed if actor.grab_target
      actor.grab_target = nil
    end
  end
end
