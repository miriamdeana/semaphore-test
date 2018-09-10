# PipeHostRewriter
#   A Rack middleware to rewrite the HTTP Host header for requests received
#
#
#   It's all transperant to your application, it performs cname lookup and
#   overwrite HTTP_HOST if needed
#
#   www.example.org  =>  example.myapp.com
#
class PipeHostRewriter

  def initialize(app)
    @app = app
  end

  def call(env)
    if env['PATH_INFO'] != '/sidekiq' && env['HTTP_X_ORIGINAL_HOST']
      env['HTTP_HOST'] = env['HTTP_X_ORIGINAL_HOST']
    end

    @app.call(env)
  end
end
