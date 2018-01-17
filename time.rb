class Time

  FORMATS = { "year" => "%Y", "month" => "%m", "day" => "%d", "hour" => "%H", "minute" => "%M" , "second" => "%S" } 

  attr_reader :request, :delimeters, :query, :formats, :unknown_format 

  def call(env)

    @request = Rack::Request.new(env)

    if @request.path_info == "/time"
      time_url
    else
      unknown_url
    end

  end

  private

  def unknown_url
    [
      400,
      { 'Content-Type' => 'text/plain' },
      ["Unknown url\n"]
    ]
  end

  def time_url
    check_query_string

    if @unknown_format
      failed
    else
      success
    end

  end

  def check_query_string
    @unknown_format = false

    parse_string_query
    find_delimeters
    formats
    time_format
  end

  def parse_string_query
    @query = Rack::Utils.parse_query(@request.query_string)["format"]
  end

  def find_delimeters()
    @delimeters = []
    @query.split('').each { |char| @delimeters << char if char.ord < 65 }
  end

  def formats
    @formats = @query.tr(@delimeters.join, " ").split
  end

  def time_format
    @output = ""
    @unknown_list = []

    @formats.each_with_index do |format, index|
      if FORMATS[format]
        @output << FORMATS[format]
        @output << @delimeters[index] unless format == @formats.last
      else
        @unknown_format = true
        @unknown_list << format
      end
    end
  end

  def failed
    [
      400,
      { 'Content-Type' => 'text/plain' },
      ["Unknown time format #{@unknown_list}\n"]
    ]
  end

  def success
    time = Time.now.strftime(@output)

    [
      200,
      { 'Content-Type' => 'text/plain' },
      ["#{time}\n"]
    ]
  end

end