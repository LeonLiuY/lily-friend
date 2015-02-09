require 'sinatra'


get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end


post '/convert' do
  text = request.body.read
  text.upcase
end