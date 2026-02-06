# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  email                   :string
#  encrypted_password      :string           default(""), not null
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

  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }
  validates :username, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "can only contain letters, numbers, and underscores" }
end
