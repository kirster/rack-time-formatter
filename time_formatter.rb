class TimeFormatter

  FORMATS = { "year" => "%Y", "month" => "%m", "day" => "%d", "hour" => "%H", "minute" => "%M" , "second" => "%S" }.freeze

  def initialize(input_format)
    @input_format = input_format
    @unknown_format_list = []
  end

  def format
    delimeters = find_delimeters
    formats = get_formats(delimeters)
    check_formats(formats, delimeters)
    result
  end

  private

  def find_delimeters
    delimeters = []
    @input_format.split('').each { |char| delimeters << char if char.ord < 65 }
    delimeters
  end

  def get_formats(delimeters)
    @input_format.tr(delimeters.join, " ").split
  end

  def check_formats(formats, delimeters)
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

  def result
    @unknown_format_list.empty? ? @time_format : @unknown_format_list
  end
  
end