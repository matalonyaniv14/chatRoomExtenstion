require 'csv'
require 'json'
require_relative '../Models/message.rb'

CSV_OPTIONS  = {headers: true, header_converters: :symbol } 
MESSAGE_FILE = 'src/data/chat_room_data.csv'

class MessageRepo 
    def initialize()
        @messages = load_messages
    end 


    def last
        @messages.size.zero?  ?  [{}] :  @messages.last.attributes
    end 

    def update(messages)
        CSV.open(MESSAGE_FILE, 'a+') do |csv|
            messages.each do |m|
                m[:timestamp] = DateTime.now.to_time.to_s
                message = Message.new(m)
                if message._valid?
                    @messages << message
                    csv << message.to_csv
                end 
            end 
        end 
    end 



    private


    def load_messages
        data = CSV.read(MESSAGE_FILE, CSV_OPTIONS)
        if data 
             messages = data.size <= 100 ? data : data[(data.size - 100)..-1]
             message_objects = []
             messages =  messages.each do |m|
                message = Message.new(m.to_h) rescue next
                if message._valid?  
                    message_objects << message
                end 
             end 

             return message_objects
        end  

        return []
    end 
end 
