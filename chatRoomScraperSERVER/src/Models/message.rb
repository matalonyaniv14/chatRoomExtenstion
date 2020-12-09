require "byebug"

class Message
  attr_accessor :author, :content

  def initialize(params = { author: "", content: "", timestamp: "" })
    @author = params[:author].strip
    @content = params[:content].strip
    @timestamp = params[:timestamp].strip
  end

  def self.build(message)
    message[:timestamp] = DateTime.now.to_time.to_s
    return new(message)
  end

  def to_csv
    self.attributes.values
  end

  def _valid?
    return false unless smarter_trader?

    self.attributes.values.all? do |val|
      !val.to_s.empty?
    end
  end

  def smarter_trader?
    self.author =~ /^smartertrader$/
  end

  def attributes
    _attributes = {}
    self.instance_variables.each do |var|
      key = var.to_s.split("@").join.to_sym
      val = self.instance_variable_get(var)
      _attributes[key] = val
    end

    return _attributes
  end
end
