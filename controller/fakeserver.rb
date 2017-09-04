require 'sinatra'
require 'json'
require 'net/http'

def setJson
  h = {query: "how to read a file", id: "123"}
  return h.to_json
end

get '/teste' do
  headers ({"Content-Type" => "application/json"})
  body setJson()
end

after '/teste' do
  uri = URI.parse("http://localhost:1111/teste")
  header = {"Content-Type" => 'application/json'}

  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = setJson()

# Send the request
  response = http.request(request)
end




before '/response' do
  request.body.rewind
  @request_payload = request.body.read
  puts @request_payload
end

get '/response' do
  "success"
end