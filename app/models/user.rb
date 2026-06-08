# == Schema Information
#
# Table name: users
#
#  id                          :bigint           not null, primary key
#  bio                         :text
#  email                       :string
#  email_frequency             :string
#  encrypted_password          :string           default(""), not null
#  last_recommendation_sent_at :datetime
#  name                        :string
#  password                    :string
#  receive_recommendations     :boolean
#  remember_created_at         :datetime
#  reset_password_sent_at      :datetime
#  reset_password_token        :string
#  username                    :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_users_on_email                        (email) UNIQUE
#  index_users_on_last_recommendation_sent_at  (last_recommendation_sent_at)
#  index_users_on_reset_password_token         (reset_password_token) UNIQUE
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

  scope :recommendation_recipients, -> { where(receive_recommendations: true).where.not(email_frequency: nil) }

  has_many :chat_sessions, dependent: :destroy
  has_many :chat_messages, through: :chat_sessions

  def due_for_recommendations?(date = Date.current)
    return false unless receive_recommendations? && email_frequency.present?
    return false if last_recommendation_sent_at.present? && sent_in_same_delivery_period?(date)

    case email_frequency
    when "daily"
      true
    when "weekly"
      date.monday?
    when "biweekly"
      ((date.cweek - 1) / 2).even?
    when "monthly"
      date.day == 1
    else
      false
    end
  end

  def active_chat_session
    chat_sessions.active.last || chat_sessions.create!(started_at: Time.current)
  end

  def self.send_recommendation_email!(user_or_id)
    user = user_or_id.is_a?(User) ? user_or_id : find_by(id: user_or_id)
    return false unless user

    SendRecommendationEmailJob.perform_now(user.id)
    true
  end

  def self.send_due_recommendation_emails!(date = Date.current)
    delivered_count = 0
    recommendation_recipients.find_each do |user|
      next unless user.due_for_recommendations?(date)

      SendRecommendationEmailJob.perform_now(user.id)
      delivered_count += 1
    end
    delivered_count
  end

  private

  def sent_in_same_delivery_period?(date)
    return false unless last_recommendation_sent_at

    sent_date = last_recommendation_sent_at.to_date
    case email_frequency
    when "daily"
      sent_date == date
    when "weekly"
      sent_date.cweek == date.cweek && sent_date.year == date.year
    when "biweekly"
      ((sent_date.cweek - 1) / 2) == ((date.cweek - 1) / 2) && sent_date.year == date.year
    when "monthly"
      sent_date.month == date.month && sent_date.year == date.year
    else
      false
    end
  end
end
