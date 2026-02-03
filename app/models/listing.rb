# == Schema Information
#
# Table name: listings
#
#  id           :bigint           not null, primary key
#  address      :string
#  city         :string
#  details      :text
#  neighborhood :text
#  state        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#
class Listing < ApplicationRecord
end
