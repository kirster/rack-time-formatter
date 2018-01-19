class Time

  FORMATS = { "year" => "%Y", "month" => "%m", "day" => "%d", "hour" => "%H", "minute" => "%M" , "second" => "%S" }

  attr_reader :time_format, :unknown_format_list 

  def call(env)
    @unknown_format_list = []

    format = Rack::Request.new(env).params["format"]
    check_query_string(format)
  end

  private

  def check_query_string(format)
    delimeters = find_delimeters(format)

    formats = get_formats(format, delimeters)

    result(formats, delimeters)
  end

  def find_delimeters(format)
    delimeters = []
    format.split('').each { |char| delimeters << char if char.ord < 65 }
    delimeters
  end

  def get_formats(format, delimeters)
    format.tr(delimeters.join, " ").split
  end

  def result(formats, delimeters)
    str_format = ""

    formats.each_with_index do |format, index|
      if FORMATS[format]
        str_format << FORMATS[format]
        str_format << delimeters[index] if delimeters[index]
      else
        @unknown_format_list << format
      end
    end
    @time_format = Time.now.strftime(str_format)
  end

end