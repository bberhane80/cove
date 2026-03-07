# == Schema Information
#
# Table name: chat_messages
#
#  id              :bigint           not null, primary key
#  content         :text
#  role            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  chat_session_id :bigint           not null
#
# Indexes
#
#  index_chat_messages_on_chat_session_id  (chat_session_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_session_id => chat_sessions.id)
#
class ChatMessage < ApplicationRecord
  belongs_to :chat_session
  
  validates :role, presence: true, inclusion: { in: %w[user assistant system] }
  validates :content, presence: true
  
  scope :by_user, -> { where(role: 'user') }
  scope :by_assistant, -> { where(role: 'assistant') }
end
