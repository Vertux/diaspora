module GPIO
  def self.write(value=:high, pin=0)
    value = ([:high, 1, "1", :on, "high", "on", "HIGH", "ON"].include?(value)) ? 1 : 0
    open("/sys/class/gpio/gpio#{pin}/value", "w") do |io|
      io.write(value)
    end
  end

  def self.on(pin=0)
    self.write(:high, pin)
  end
  
  def self.off(pin=0)
    self.write(:low, pin)
  end
end
