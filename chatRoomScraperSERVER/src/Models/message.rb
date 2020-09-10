require 'byebug'

class Message
    attr_accessor :author, :content

    def initialize(params = {author: '', content: '', timestamp: '' })  
        @author  = params[:author].strip
        @content = params[:content].strip
        @timestamp = params[:timestamp].strip
    end 

    def to_csv 
        self.attributes.values
    end 

    def _valid?
      self.attributes.values.all? do |val|
        !val.to_s.empty?
      end 
    end 


    def attributes 
        _attributes = {}
        self.instance_variables.each do |var|
            key = var.to_s.split('@').join.to_sym
            val = self.instance_variable_get(var)
            _attributes[key] = val
        end 

        return _attributes
    end 
end 