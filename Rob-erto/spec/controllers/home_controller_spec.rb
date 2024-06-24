require 'rails_helper'

# configurazione Capybara (utilizza driver di chrome)
Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.default_driver = :selenium_chrome
Capybara.javascript_driver = :selenium_chrome
Capybara.default_max_wait_time = 5  # Tempo massimo di attesa


# Scambio di messaggi
RSpec.describe "Chat", type: :feature do
  it "sends a message to the AI and receives a response" do
    visit root_path
    fill_in "user_input", with: "Hello!"
    click_button "send_button"

    # Aspetta che i chatbox appaiano sulla pagina (dopo esecuzione di send_msg) e verifica il contenuto
    expect(page).to have_xpath("(//li[contains(@class, 'chatbox outgoing')])[last()]/p", text: "Hello!", visible: true)
    expect(page).to have_xpath("(//li[contains(@class, 'chatbox incoming')])[last()]/p", text: /./, visible: true)
  end
end

# Creazione di una nuova chat
RSpec.describe "CreateChat", type: :feature do
  # crea utente
  let (:user) { User.create!(email: "test@example.com", password: "testpassword", name: "testuser", provider: "github", uid: "123545", nickname: "testuser") }
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: 'github',
      uid: '123545',
      info: {
        email: user.email,
        name: user.name,
      },
      credentials: {
        token: "mock_token",
        secret: "mock_secret"
      }
    })
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
    
    visit user_github_omniauth_authorize_path
    page.set_rack_session(user_id: user.id)
    page.set_rack_session(first_visit: false)
    visit root_path
  end

  it "creates a new chat" do
    expect(page).to have_selector("#crea_chat_button")
    click_button "crea_chat_button"

    within('.partial_test') do
      # Trova l'ultimo elemento <li> nella lista
      last_chat_item = all('li').last
      # Verifica che l'ultimo elemento <li> contenga la scritta "Nuova chat"
      expect(last_chat_item).to have_content("Nuova chat")
    end
  end
  
  after do
    OmniAuth.config.test_mode = false
  end

end

RSpec.describe HomeController, type: :controller do

  describe "POST #send_msg" do
    before do
      user = User.create!(email: "fake@email", password: "fakepassword")
      chat = Chat.create!(user_id: user.id)
      session[:chat_id] = chat.id
      session[:messages] = []
    end

    it "sends a message to the AI" do
      post :send_msg, params: { user_input: "Hello!" }

      expect(response).to redirect_to(action: :index)
      expect(session[:messages].last).to eq({"role": "user", "content": "Hello!"})
    end

    it "receives a response from the AI" do
      post :send_msg, params: { user_input: "Hello!" }

      expect(response).to redirect_to(action: :index)
      expect(session[:response]).not_to be_nil
    end
  end


  describe "POST #create_chat" do
    before do
      user = User.create!(email: "fake@email", password: "fakepassword")
      session[:user_id] = user.id
    end

    it "creates a new chat" do
      expect {
        post :create_chat
      }.to change(Chat, :count).by(1)   # Verifica che il numero di chat sia aumentato di 1

      expect(response).to redirect_to(action: :index)
    end
  end

end
