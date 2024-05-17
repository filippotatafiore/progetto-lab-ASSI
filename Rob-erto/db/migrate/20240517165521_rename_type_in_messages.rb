class RenameTypeInMessages < ActiveRecord::Migration[6.1]
  def change
    rename_column :messages, :type, :message_type
  end
end
