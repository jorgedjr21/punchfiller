# frozen_string_literal: true
require 'mechanize'
require 'colorize'

require_relative "punchfiller/version"
require_relative 'punchfiller/login'
require_relative 'punchfiller/constants'
require_relative 'punchfiller/last_punch'
require_relative 'punchfiller/punchs_to_fill'

module Punchfiller

  def self.run
    agent = Mechanize.new

    login = Login.new(agent: agent)

    login.ask_credentials
    index = login.perform_login

    last_punch_instance = LastPunch.new(page: index)
    punchs_to_fill = PunchsToFill.new(last_punch_date: last_punch_instance.last_punch_date)
    last_punch_instance.last_punch_info
    punchs_to_fill.dates_to_fill_info


    # if last_punch_instance.last_punch_confirmated?(last_punch_instance.last_punch)
    #   punchs_to_fill = PunchsToFill.new(last_punch_date: last_punch_instance.last_punch_date)
    #   p punchs_to_fill.dates
    # else
    #     print 'Exiting...'
    # end
  end
end

Punchfiller.run
