# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  bio                     :text
#  email                   :string
#  encrypted_password      :string           default(""), not null
#  name                    :string
#  password                :string
#  receive_recommendations :boolean
#  remember_created_at     :datetime
#  reset_password_sent_at  :datetime
#  reset_password_token    :string
#  username                :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_listings, through: :bookmarks, source: :listing

  validates :name, length: { maximum: 100 }, allow_blank: true
  validates :username, presence: true, uniqueness: true, length: { maximum: 50 }

  validates :bio, length: { maximum: 500 }, allow_blank: true
end
