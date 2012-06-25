
# A behavior for actors that behave like a physical ball (circle) with
# a certain radius, density, elasticity, and friction. This behavior
# adds the :physical behavior at setup time, so the actor should NOT
# use :physical behavior explicitly, or it may interfere.
#
define_behavior :bally do
  setup do
    actor.has_attributes( radius:        10,
                          density:       20,
                          elasticity:    0.5,
                          friction:      0.8 )

    add_behavior( :physical,
                  shape:  :circle,
                  radius: actor.radius,
                  mass:   actor.density * actor.radius**2 * Math::PI,
                  elasticity: actor.elasticity,
                  friction:   actor.friction )
  end
end
