# frozen_string_literal: true
require 'mechanize'
require 'colorize'
require 'tty-spinner'

require_relative "punchfiller/version"
require_relative 'punchfiller/login'
require_relative 'punchfiller/constants'
require_relative 'punchfiller/last_punch'
require_relative 'punchfiller/punchs_to_fill'
require_relative 'punchfiller/punchlock'

module Punchfiller

  def self.run
    config_spinners
    agent = Mechanize.new
    index = perform_login(agent)

    last_punch_instance = LastPunch.new(page: index)
    @spinner_last_punch.run('ok'.green) do |spinner|
      last_punch_instance.get_last_punch
    end

    punchs_to_fill = PunchsToFill.new(last_punch_date: last_punch_instance.last_punch_date)
    @spinner_fill_punchs.run('ok'.green) do |spinner|
      punchs_to_fill.process_dates_to_fill
    end

    last_punch_instance.last_punch_info
    punchs_to_fill.dates_to_fill_info

    if user_accept?
      dates = punchs_to_fill.dates
      times = Constants::TIMES_TO_FILL
      punchlock = Punchlock.new(index: index, dates: dates, times: times)

      punchlock.fill_all
    else
      print 'Exiting...'
    end
  end

  def self.user_accept?
    print "Please check if all data is correct.\nDo you wanna continue? (y/N)?".red

    gets.chomp == 'y'
  end

  private

  def self.config_spinners
    @spinner_login = TTY::Spinner.new('[:spinner] login..', format: :dots, success_mark: '✔'.green, )
    @spinner_last_punch = TTY::Spinner.new('[:spinner] getting last punchs..', format: :dots_2, success_mark: '✔'.green)
    @spinner_fill_punchs = TTY::Spinner.new('[:spinner] getting punchs to fill..', format: :dots_3, success_mark: '✔'.green)
  end

  def self.perform_login(agent)
    index = nil
    login = Login.new(agent: agent)

    login.ask_credentials

    @spinner_login.run('ok'.green) do |spinner|
      index = login.perform_login
    end

    index
  end
end
