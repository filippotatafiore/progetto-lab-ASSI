class AddTypeToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :type, :integer
  end
end
