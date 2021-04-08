# frozen_string_literal: true
require 'mechanize'
require_relative "punchfiller/version"
require_relative 'punchfiller/login'
require_relative 'punchfiller/constants'

module Punchfiller

  def self.run
    agent = Mechanize.new

    login = Login.new(agent: agent)

    login.ask_credentials
    login.perform_login
    index = login.page_state

    headers = get_table_headers(index)

    last_punch = get_last_punch(index, headers)

    puts last_punt_confirmation(last_punch)
  end
end

Punchfiller.run
