require_relative 'constants'

class LastPunch
  attr_reader :last_punch

  def initialize(page:)
    @page = page
    @last_punch = {}
    get_last_punch
  end

  def last_punch_date
    return if @last_punch.nil? || @last_punch[:date].nil?

    DateTime.parse(@last_punch[:date])
  end

  def last_punch_info
    message = "Last punch: \n\n".bold
    @last_punch.each do |k,v|
      message += "#{Constants::ROWS.key(k)}: #{v}\n"
    end

    print "#{message}\n"
  end

  private

  def get_last_punch
    headers = get_table_headers(@page)
    table = @page.search('table.table')
    first_td = table.xpath('//*/table/tbody/tr').first.children.reject { |row| row.text.strip.empty? }
    first_td.each_with_index do |row, index|
      header = headers.find { |h| h[:index] == index}
      next if header.nil?

      @last_punch[header[:name]] = row.text.strip
    end
  end

  def get_table_headers(page)
    headers = []
    table = page.search('table.table')
    table.xpath('//*/table/thead/tr/th').each_with_index do |th, index|
      headers << {
        name: Constants::ROWS[th.text],
        index: index
      } if Constants::ROWS.keys.include?(th.text)
    end

    headers
  end
end
