require_relative 'time_formatter'

class App

  def call(env)
    @request = Rack::Request.new(env)
    @response = Rack::Response.new

    case @request.path_info
      when "/time"
        @result = TimeFormatter.new(@request.params["format"]).format
        @result.instance_of?(String) ? success : failed
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
    @response.write "Unknown time format #{@result}\n"
    @response.headers['Content-Type'] = 'text/plain'
    @response.finish
  end

  def success
    @response.status = 200
    @response.write "#{@result}\n"
    @response.headers['Content-Type'] = 'text/plain'
    @response.finish
  end

end 
