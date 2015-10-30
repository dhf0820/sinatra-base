require 'sinatra'
require 'sinatra/base'

# Alpine Sinatra application class
class App < Sinatra::Base
  get '/' do
    'Hello from test in Docker!'
  end

  # Show environment info
  get '/env' do
    'Environment:' \
    '<ul>' +
      ENV.each.map { |k, v| "<li><strong>#{k}:</strong> #{v}</li>" }.join +
      '</ul>'
  end

  # Show disk info
  get '/disk' do
    "<strong>Disk:</strong><br/><pre>#{`df -h`}</pre>"
  end

  # Show memory info
  get '/memory' do
    "<strong>Memory:</strong><br/><pre>#{`free -m`}</pre>"
  end

  # Exit 'correctly'
  get '/exit' do
    # /exit causes:
    # 15:20:24 web.1  | Damn!
    # 15:20:24 web.1  | exited with code 1
    Process.kill('TERM', Process.pid)
  end

  # Just terminate
  get '/fail' do
    Process.kill('KILL', Process.pid)
  end

  # Artificial delay...
  get '/sleep' do
    # Just sleep...
    seconds = params[:seconds].to_f || 1.0
    sleep seconds
    "Wasted #{seconds} sec.<br/><strong>ProTip:</strong> use `/sleep?seconds=3`"
  end
end
