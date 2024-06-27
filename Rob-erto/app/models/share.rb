class Share < ActiveRecord::Base
    belongs_to :user
    belongs_to :destinatario, class_name: 'User'
    belongs_to :chat
end
