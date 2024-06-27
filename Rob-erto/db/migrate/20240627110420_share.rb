class Share < ActiveRecord::Migration[6.1]
  def change
    create_table :shares do |t|
      t.integer :mittente
      t.integer :destinatario
      t.integer :chat_id

      t.timestamps
    end
  end
end
