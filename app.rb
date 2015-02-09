require 'sinatra'


get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

NAME='music'

post '/convert' do
  text = request.body.read
  dir = Dir.mktmpdir
  puts dir
  File.open(File.join(dir, "#{NAME}.ly"), 'w') {|f|
    f.write(text)
  }
  out = %x(cd #{dir} && lilypond -dbackend=svg #{NAME}.ly 2>&1)
  puts out
  exit_code = $?.exitstatus
  if exit_code == 0
    status 200
    body dir
  else
    status 400
    body out
  end
end

get '/scores' do
  path = params[:path]
  send_file File.join(path, 'music.svg')
end