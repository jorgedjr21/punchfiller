require_relative 'lib/constants'
class Login
  attr_reader :page_state

  def initialize(agent: agent)
    @agent = agent
  end

  def perform_login
    page = @agent.get(Constants::PUNCHLOCK_URL)
    form = page.form_with(action: '/users/sign_in')
    form.field_with(name: 'user[email]').value = 'jorge.david@codeminer42.com'
    form.field_with(name: 'user[password]').value = '210191Jj'
    @page_state = form.submit
  end

end
