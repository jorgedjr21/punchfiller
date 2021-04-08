require 'constants'

class LastPunch
  def initialize(agent:)
    @agent = agent
    @td = {}
  end

  def get_last_punch(page, headers)
    table = page.search('table.table')
    first_td = table.xpath('//*/table/tbody/tr').first.children.reject { |row| row.text.strip.empty? }
    first_td.each_with_index do |row, index|
      header = headers.find { |h| h[:index] == index}
      next if header.nil?

      @td[header[:name]] = row.text.strip
    end
  end

  def last_punt_confirmation(last_punch)
    message = "Is this your last punch? (y/N) \n"
    last_punch.each do |k,v|

      message += "#{ROWS.key(k)}: #{v}\n"
    end

    message
  end

  private

  def get_table_headers(page)
    headers = []
    table = page.search('table.table')
    table.xpath('//*/table/thead/tr/th').each_with_index do |th, index|
      headers << {
        name: Constants::ROWS[th.text],
        index: index
      } if ROWS.keys.include?(th.text)
    end

    headers
  end
end
