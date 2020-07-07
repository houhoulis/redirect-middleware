# frozen_string_literal: true

class Redirect

  # The second parameter might look like:
  #   { "/example" => "https://example.org", "/x" => "https://www.x.org" }
  def initialize app, redirect_map:
    @app = app
    @redirect_map = redirect_map.is_a?(Hash) ? redirect_map : {}
  end

  def call env
    request_path = env['PATH_INFO']

    if @redirect_map.keys.include? request_path
      begin
        destination = @redirect_map[request_path]
        log_impending_redirect env, request_path, destination
        [301, {'Location' => destination}, []]
      rescue StandardError => _
        @app.call env
      end
    else
      @app.call env
    end
  end

  def log_impending_redirect env, request_path, destination
    logger = env['action_dispatch.logger'] || env['rack.logger']
    message = "Hi. Redirect middleware intercepted #{request_path}. Redirecting to #{destination}. Bye."
    if logger.respond_to? :info
      logger.info message
    elsif logger.respond_to? :<<
      logger << message
    elsif logger.respond_to? :write
      logger.write message
    end
  end

end
