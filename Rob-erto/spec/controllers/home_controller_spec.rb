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
  before do
    # Crea utente
    #usr = User.create!(email: "test@example.com", password: "testpassword", name: "testuser", provider: "github", uid: "123545", nickname: "testuser")
    #User.create!(id: 4, email: "test@example.com", password: "testpassword", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, name: "testuser", created_at: "2024-06-20 11:09:34.771206000 +0000", updated_at: "2024-06-23 19:44:32.789394000 +0000", provider: "github", uid: "123545", sign_in_count: 22, current_sign_in_at: "2024-06-23 19:44:32.789394000 +0000", last_sign_in_at: "2024-06-23 19:44:32.789394000 +0000", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", profile_image: 36, nickname: "testuser")
    # Configura Omniauth Mocks
    OmniAuth.config.test_mode = true
    usr = Faker::Omniauth.github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(usr)
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]

    # # login utente
    # sign_in usr
    # # verifica login
    # visit profilo_index_path
    # expect(page).to have_text("testuser")
    # visit root_path
    # expect(page).to have_selector("#crea_chat_button")
    # expect(page).to have_text("cacca")

    # get user_omniauth_authorize_path(:github)
    # follow_redirect!
    
    visit user_github_omniauth_authorize_path
    visit user_github_omniauth_callback_path
    user = User.find_by(name: usr[:info][:name], email: usr[:info][:email])
    expect(user).not_to be_nil
    visit profilo_index_path
    expect(page).to have_text("Informazioni Generali:")

    # visit profilo_index_path
    # expect(page).to have_button("Entra con GitHub")
    # click_button "Entra con GitHub"
    #save_and_open_screenshot


    # Verifiche post-login
    # expect(page).to have_text("Logged in successfully")   # Verifica messaggio di successo
    # expect(page).to have_selector('.swal-overlay.swal-overlay--show-modal')
    # within('.swal-overlay.swal-overlay--show-modal') do
    #   within('.swal-modal') do
    #     within('.swal-text') do
    #       expect(page).to have_text("Logged in successfully")   # Verifica messaggio di successo
    #     end
    #   end
    # end

  end

  it "creates a new chat" do
    visit root_path
    expect(page).to have_selector("#crea_chat_button")
    find("#crea_chat_button").click

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


  describe "GET #index" do
    before do
      session[:first_visit] = false
      usr = User.create!(email: "test@example.com", password: "testpassword", name: "testuser", provider: "github", uid: "123545", nickname: "testuser")
      sign_in usr
      expect(session[:user_id]).to eq(usr.id)
    end

    it "cheks that after a login the user is no longer a base user" do
      get :index
      expect(session[:user_name]).not_to eq('base_user')
      expect(assigns(:list_visibility)).to be true
    end
  end

end
