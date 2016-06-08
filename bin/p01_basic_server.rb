require 'rack'

# Rack::Server.start(
#   app: Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['Hello World']] }
# end
# )

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'
  # res.write("Hello world!")
  res.write(req.path_info)
  # res.write("#{env}")
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
