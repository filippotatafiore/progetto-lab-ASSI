class Chat < ApplicationRecord
    belongs_to :user
    has_many :messages, dependent: :destroy
    has_many :shares, dependent: :destroy
end
