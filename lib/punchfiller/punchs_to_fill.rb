class PunchsToFill
  attr_reader :dates
  def initialize(last_punch_date: )
    @last_punch_date = last_punch_date

  end

  def dates_to_fill_info
    message = "Dates to fill: \n\n".bold
    message += "#{readable_dates.join(', ')} \n"

    print "#{message}\n"
  end

  def readable_dates
    @dates.map { |date| date.strftime('%A - %d/%m/%Y') }
  end

  def process_dates_to_fill
    @dates = (@last_punch_date..Date.today).to_a
    @dates.shift
    @dates.reject! { |date| date.saturday? || date.sunday? }
  end
end
