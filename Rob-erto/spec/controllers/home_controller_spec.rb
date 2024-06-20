require 'rails_helper'
# Capybara.default_driver = :selenium

# RSpec.describe "Chat", type: :feature do
#   it "sends a message to the AI and receives a response" do
#     visit root_path
#     fill_in "user_input", with: "Hello!"
#     click_button "send_button"

#     Capybara.default_max_wait_time = 5  # Aumenta il tempo massimo di attesa
#     # Aspetta che i chatbox appaiano sulla pagina (dopo esecuzione di send_msg)
#     expect(page).to have_css(".chatbox.outgoing:last-child p", text: "Hello!", visible: true)
#     expect(page).to have_css(".chatbox.incoming:last-child p", text: /./, visible: true)

#   end
# end

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

      expect(response).to be_successful
      expect(session[:messages].last["content"]).to eq("Hello!")
    end

    it "receives a response from the AI" do
      post :send_msg, params: { user_input: "Hello!" }

      expect(response).to be_successful
      expect(session[:response]).not_to be_nil
    end
  end
end
