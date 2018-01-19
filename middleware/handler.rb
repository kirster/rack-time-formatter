class Handler

  def initialize(time)
    @time = time
  end

  def call(env)
    @request = Rack::Request.new(env)
    @response = Rack::Response.new

    case @request.path_info
      when "/time"
        @time.call(env)
        @time.unknown_format_list.empty? ? success : failed
      else 
        unknown_handler
    end

  end

  private

  def unknown_handler
    @response.status = 404
    @response.write "Not found\n"
    @response.headers['Content-Type'] = 'text/plain'
    @response.finish
  end

  def failed
    @response.status = 400
    @response.write "Unknown time format #{@time.unknown_format_list}\n"
    @response.headers['Content-Type'] = 'text/plain'
    @response.finish
  end

  def success
    @response.status = 200
    @response.write "#{@time.time_format}\n"
    @response.headers['Content-Type'] = 'text/plain'
    @response.finish
  end

end