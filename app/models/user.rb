# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  bio                     :text
#  email                   :string
#  email_frequency         :string
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
#  id                      :bigint           not null, primary key

#  bio                     :text
#  email                   :string
#  email_frequency         :string
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

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 20 },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "can only contain letters, numbers, and underscores" }

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  validates :password, length: { minimum: 6, maximum: 128 }, allow_blank: true

  validates :name, length: { maximum: 100 }, allow_blank: true
  validates :bio, length: { maximum: 500 }, allow_blank: true

  EMAIL_FREQUENCIES = {
    "daily" => "Daily",
    "weekly" => "Weekly",
    "biweekly" => "Every 2 weeks",
    "monthly" => "Monthly"
  }.freeze
  validates :email_frequency, inclusion: { in: EMAIL_FREQUENCIES.keys }, allow_nil: true

    EMAIL_FREQUENCIES = {
      "daily" => "Daily",
      "weekly" => "Weekly",
      "biweekly" => "Every 2 weeks",
      "monthly" => "Monthly"
    }.freeze
    validates :email_frequency, inclusion: { in: EMAIL_FREQUENCIES.keys }, allow_nil: true
end
