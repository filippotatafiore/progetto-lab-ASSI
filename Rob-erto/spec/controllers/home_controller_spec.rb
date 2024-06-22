require 'rails_helper'

# configurazione Capybara (utilizza driver di chrome)
Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.default_driver = :selenium_chrome
Capybara.javascript_driver = :selenium_chrome
Capybara.default_max_wait_time = 5  # Aumenta il tempo massimo di attesa


RSpec.describe "Chat", type: :feature do
  it "sends a message to the AI and receives a response" do
    visit root_path
    fill_in "user_input", with: "Hello!"
    #expect(page).to have_field("user_input", with: "Hello!")
    click_button "send_button"

    # Aspetta che i chatbox appaiano sulla pagina (dopo esecuzione di send_msg) e verifica il contenuto
    expect(page).to have_xpath("(//li[contains(@class, 'chatbox outgoing')])[last()]/p", text: "Hello!", visible: true)
    expect(page).to have_xpath("(//li[contains(@class, 'chatbox incoming')])[last()]/p", text: /./, visible: true)
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
end
