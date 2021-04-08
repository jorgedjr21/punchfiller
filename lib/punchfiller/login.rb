require_relative 'constants'
class Login
  attr_reader :page_state
  attr_reader :email, :password

  def initialize(agent:)
    @agent = agent
  end

  def ask_credentials
    puts 'Enter your email: '
    @email = gets.chomp

    puts 'Enter the password:'
    @password = gets.chomp

    puts 'Enter the 2FA code: (look if the 2FA code has enough time before expiring)'
    @twofactorcode = gets.chomp
  end

  def perform_login
    page = @agent.get(Constants::PUNCHLOCK_URL)
    form = page.form_with(action: '/users/sign_in')
    form.field_with(name: 'user[email]').value = @email
    form.field_with(name: 'user[password]').value = @password
    form.field_with(name: 'user[otp_attempt]').value = @twofactorcode
    @page_state = form.submit
  end

end
