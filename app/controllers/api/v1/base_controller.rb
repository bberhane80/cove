
class Api::V1::BaseController < ApplicationController
	skip_before_action :authenticate_user!

	def status
		render json: { status: 'ok', time: Time.now }
	end
end
