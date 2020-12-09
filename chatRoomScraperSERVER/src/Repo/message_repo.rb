require "csv"
require "json"
require "byebug"
require_relative "../Models/message.rb"

class MessageRepo
  CSV_OPTIONS = { headers: true, header_converters: :symbol, col_sep: ";" }

  def initialize(path)
    @path = path
    @messages = load_messages
  end

  def last
    @messages.size.zero? ? [{}] : @messages.last.attributes
  end

  def update(messages)
    new_messages = []
    CSV.open(@path, "a+", col_sep: ";") do |csv|
      messages.each do |m|
        message = Message.build(m)
        next if message_exists?(message)

        if message._valid?
          self.safe_push(@messages, message)
          csv << message.to_csv
          new_messages << message
        end
      end
    end

    return new_messages
  end

  def find(message)
    @messages.select do |m|
      m.author =~ /^#{message.author}$/ &&
      m.content =~ /^#{message.content}$/
    end
  end

  def message_exists?(message)
    !self.find(message).size.zero?
  end

  def safe_push(array, other)
    difference = array.size - 100
    array.shift(difference) if difference > 0
    array.push(other)

    return array
  end

  private

  def load_messages
    data = CSV.read(@path, CSV_OPTIONS)
    if data
      messages = data.size <= 100 ? data : data[(data.size - 100)..-1]
      message_objects = []
      messages.each do |m|
        message = Message.new(m.to_h) rescue next
        if message._valid?
          message_objects << message
        end
      end

      return message_objects
    end
  end
end
