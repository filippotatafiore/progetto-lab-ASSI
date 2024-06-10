class AddProfileImageToUtenti < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :profile_image, :integer
  end
end
