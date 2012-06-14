class DemoStage < Stage
  def setup
    super
    @gribble = spawn( :gribble,
                      x: 30, y: 30,
                      color: Color::RED,
                      radius: 20 )
  end
end

