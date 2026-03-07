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
end
