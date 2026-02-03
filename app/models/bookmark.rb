# == Schema Information
#
# Table name: bookmarks
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  listing_id :integer
#  user_id    :integer
#
class Bookmark < ApplicationRecord
 belongs_to :user
  belongs_to :listing

  validates :user_id, uniqueness: { scope: :listing_id }
end
