
# This behavior allows an actor to change between behavior "modes".
# Each mode is a behavior. Only one mode can be active at a time. When
# the actor changes modes, the current mode behavior is removed from
# the actor, then the new mode behavior is added to the actor.
#
# Use change_mode to change the mode behavior, or disable the mode
# behavior (by passing nil). Use change_mode! if you want to forcibly
# change modes, even if the new mode is the same as the old mode.
#
# This behavior supports two options:
#
# - :default : the actor's starting mode (behavior name)
# - :modes : a hash of allowed behavior names and options (the name
#            and options are are passed to #add_behavior), e.g.
#            {:behavior1 => opts1, :behavior2 => opts2, ...}.
#            For convenience, if none of the behaviors have options,
#            you can instead give an array of behavior names, e.g.
#            [:behavior1, :behavior2, ...].
#
# Example:
#
#   define_behavior :robot_mode do
#     # ...
#   end
#
#   define_behavior :vehicle_mode do
#     # ...
#   end
#
#   define_actor :transformer do
#     has_behavior :modal => {
#       :default => :robot_mode,
#       :modes => {
#         :robot_mode => { speed: 10 },
#         :vehicle_mode => { speed: 20 }
#       }}
#   end
#
define_behavior :modal do

  setup do
    actor.has_attributes( mode: opts[:default],
                          modes: sanitize_modes(opts[:modes]) )
    reacts_with :change_mode, :change_mode!
    change_mode!(actor.mode)
  end

  helpers do

    # Changes the actor's mode to new_mode. Does nothing if the
    # actor's mode is already the same as new_mode. If new_mode is
    # nil, removes the current mode behavior without adding any other
    # mode behavior.
    def change_mode( new_mode )
      unless( actor.mode == new_mode and
              (new_mode.nil? or actor.has_behavior?(actor.mode)) )
        change_mode!( new_mode )
      end
    end

    # Same as change_mode, except that it will "change" (reset) the
    # mode even if new_mode is the same as the current mode.
    def change_mode!( new_mode )
      unless new_mode.nil? or actor.modes.has_key?(new_mode)
        raise "Unsupported mode #{new_mode} for actor #{actor}"
      end

      if actor.mode and actor.has_behavior?(actor.mode)
        actor.remove_behavior(actor.mode)
      end

      if new_mode
        mode_opts = actor.modes[new_mode]
        add_behavior(new_mode, mode_opts)
      end
      actor.mode = new_mode
    end


    private

    def sanitize_modes( modes )
      if modes.nil?
        {}
      elsif valid_modes_hash?(modes)
        modes
      elsif valid_modes_array?(modes)
        Hash.new.tap do |result|
          modes.each{ |mode| result[mode] = {} }
        end
      else
        raise "Invalid :modes option: #{modes}"
      end
    end

    def valid_modes_hash?( modes )
      modes.is_a?(Hash) and
        modes.each_pair.all? { |mode, opts|
          mode.is_a?(Symbol) and (opts.is_a?(Hash) or opts.nil?)
        }
    end

    def valid_modes_array?( modes )
      modes.is_a?(Array) and
        modes.each.all? { |mode| mode.is_a?(Symbol) }
    end

  end

end
