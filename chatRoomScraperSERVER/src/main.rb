require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require_relative 'Repo/message_repo.rb'

message_repo =  MessageRepo.new

set :port, 3001
# cors
before do 
    content_type :json
    response.headers["Access-Control-Allow-Methods"] = "HEAD,GET,PUT,OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    response.headers["Access-Control-Allow-Origin"] = '*'
end 
options "*" do
    200
end
# cors

# routes
put '/chatroom-data-upload' do 
    messages = JSON.parse(request.body.read, symbolize_names: true)
    message_repo.update(messages)

    { ok: true }.to_json
rescue 
    { ok: false }.to_json
end 

get '/chatroom-latest-message' do 
    message_repo.last.to_json
end 
# routes