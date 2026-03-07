# == Schema Information
#
# Table name: chat_sessions
#
#  id         :bigint           not null, primary key
#  ended_at   :datetime
#  started_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_chat_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class ChatSession < ApplicationRecord
  belongs_to :user
  has_many :chat_messages, dependent: :destroy
  
  validates :user, presence: true
  
  scope :active, -> { where(ended_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
  
  def active?
    ended_at.nil?
  end
  
  def end_session!
    update(ended_at: Time.current)
  end
  
  def add_message(role, content)
    chat_messages.create!(role: role, content: content)
  end
  
  def conversation_history
    chat_messages.order(:created_at).pluck(:role, :content)
  end
end
