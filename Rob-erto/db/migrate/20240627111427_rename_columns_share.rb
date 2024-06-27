class RenameColumnsShare < ActiveRecord::Migration[6.1]
  def change
    rename_column :shares, :mittente, :user_id
    rename_column :shares, :destinatario, :destinatario_id
  end
end
