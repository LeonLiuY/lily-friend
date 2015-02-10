require 'sinatra'
require 'json'

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

NAME='music'

post '/convert' do
  content_type 'application/json'
  text = request.body.read.strip
  if text.empty?
    halt 400, {out: 'Text should not be empty!'}.to_json
  end
  dir = Dir.mktmpdir
  File.open(File.join(dir, "#{NAME}.ly"), 'w') { |f|
    f.write(text)
  }
  out = %x(cd #{dir} && lilypond -dbackend=svg #{NAME}.ly 2>&1)
  exit_code = $?.exitstatus
  if exit_code == 0
    status 200
    body ({dir: dir, out: out}.to_json)
  else
    status 400
    body ({out: out}.to_json)
  end
end

get '/scores' do
  path = params[:path]
  send_file File.join(path, 'music.svg')
end
