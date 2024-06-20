require 'rails_helper'

RSpec.describe "Chat", type: :feature do
  it "sends a message to the AI and receives a response" do
    visit root_path
    fill_in "user_input", with: "Hello!"
    click_button "send_button"

    within(".chatbox.outgoing:last-child p") do
        expect(page).to have_content("Hello!")
    end
    within(".chatbox.incoming:last-child p") do
        expect(page).to have_content /./
    end
  end
end

RSpec.describe HomeController, type: :controller do
  describe "POST #send_msg" do
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
