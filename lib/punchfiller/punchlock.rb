require_relative 'constants'
require_relative 'last_punch'

class Punchlock
  def initialize(index: , dates:, times:)
    @index = index
    @dates = dates
    @times = times
  end

  def fill_all
    print "Total Punchs to fill: #{@dates.count * @times.count}\n"

    @dates.each do |date|
      fill_date = date.strftime('%d/%m/%Y')
      @times.each do |time|
        print "Filling date #{fill_date} from #{time.first} to #{time.last}..."
        access_new_punchlock

        @index = fill_punch_form(from_time: time.first, to_time: time.last, when_day: fill_date)
        raise "Can't fill your punch correctly, please check your punchs in #{Constants::PUNCHLOCK_URL}" unless last_punch_ok?(fill_date)

        print "ok\n".green
      end
    end
  end

  def fill_punch_form(from_time:, to_time:, when_day:, project: 'GetG5')
    form = @new_punch_page.form_with(method: 'POST', action: '/punches')

    form.field_with(name: 'punch[from_time]').value = from_time
    form.field_with(name: 'punch[to_time]').value   = to_time
    form.field_with(name: 'punch[when_day]').value  = when_day
    form.field_with(name: 'punch[project_id]').option_with(text: project).click

    form.submit
  end

  private

  def last_punch_ok?(fill_date)
    lp = LastPunch.new(page: @index)
    lp.get_last_punch
    lp.last_punch[:date] == fill_date
  end

  def access_new_punchlock
    new_punch_link = @index.link_with(text: 'Punch')
    @new_punch_page = new_punch_link.click
  end
end
