require "sinatra"
require "sinatra/cross_origin"
require "json"
require_relative "Repo/message_repo.rb"

csv_path = File.join(__dir__, "/data/chat_room_data_smarter.csv")
message_repo = MessageRepo.new(csv_path)
p message_repo
set :port, 3001
# cors
before do
  content_type :json
  response.headers["Access-Control-Allow-Methods"] = "HEAD,GET,PUT,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Content-Type"
  response.headers["Access-Control-Allow-Origin"] = "*"
end
options "*" do
  200
end
# cors

# routes
put "/chatroom-data-upload" do
  start_time = Time.now

  messages = JSON.parse(request.body.read, symbolize_names: true)
  new_messages = message_repo.update(messages)
  #   new messages => [Message]
  p new_messages

  { ok: true }.to_json

  puts "Total time to update => #{Time.now - start_time}"
rescue => err
  p err
  { ok: false }.to_json
end

get "/chatroom-latest-message" do
  message_repo.last.to_json
end
# routes
