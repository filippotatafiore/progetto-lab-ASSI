class AddPreferitiToChats < ActiveRecord::Migration[6.1]
  def change
    add_column :chats, :preferita, :integer, default: 0
  end
end
