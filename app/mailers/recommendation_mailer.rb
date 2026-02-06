class RecommendationMailer < ApplicationMailer
  default from: 'recommendations@rentalhub.com'

  def weekly_recommendations(user)
    @user = user
    
    # Generate AI recommendations
    service = AiRecommendationService.new(user)
    result = service.generate_recommendations
    
    return unless result && result[:success] && result[:recommendations].any?
    
    @recommendations = result[:recommendations]
    @summary = result[:summary]
    
    mail(
      to: @user.email,
      subject: "#{@user.username}, we found #{@recommendations.count} listings you might love! 🏡"
    )
  end
end
