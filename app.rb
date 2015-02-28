require 'sinatra'
require 'sinatra-websocket'
require 'json'
require 'open3'

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

NAME='music'
SF_PATH= ENV['SF_PATH'] || '/usr/share/sounds/sf2/FluidR3_GM.sf2'

get '/convert' do
  if !request.websocket?
    halt 400, 'Only accept websocket requests'
  else
    request.websocket do |ws|
      ws.onmessage do |text|
        if text.empty?
          ws.send({type: 'error', out: 'Lily text should not be empty!'}.to_json)
        else
          EM.defer do
            dir = Dir.mktmpdir
            File.open(File.join(dir, "#{NAME}.ly"), 'w') { |f|
              f.write(text)
            }
            cmd = "cd #{dir} && lilypond -dbackend=svg #{NAME}.ly 2>&1"
            Open3.popen2e(cmd) do |stdin, stdout_err, wait_thr|
              while line = stdout_err.gets
                ws.send({type: 'output', out: line}.to_json)
              end
              exit_status = wait_thr.value
              if exit_status.success?
                ws.send({type: 'success', dir: dir}.to_json)
              else
                ws.send({type: 'fail'}.to_json)
              end
            end
            if File.exists?(File.join(dir, 'music.midi'))
              ws.send({type: 'audio start'}.to_json)
              cmd = "cd #{dir} && fluidsynth -F music.wav #{SF_PATH} music.midi && lame music.wav"
              Open3.popen2e(cmd) do |stdin, stdout_err, wait_thr|
                while line = stdout_err.gets
                  ws.send({type: 'audio output', out: line}.to_json)
                end
                exit_status = wait_thr.value
                if exit_status.success?
                  ws.send({type: 'audio success'}.to_json)
                else
                  ws.send({type: 'audio fail'}.to_json)
                end
              end
            end
          end
        end
      end
    end
  end
end

get '/scores' do
  path = params[:path]
  send_file File.join(path, 'music.svg')
end

get '/audios' do
  path = params[:path]
  send_file File.join(path, 'music.mp3')
end
