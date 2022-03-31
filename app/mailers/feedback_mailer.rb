class FeedbackMailer < ApplicationMailer
  def send_feedback(user, content)
    @user = user
    @content = content
    mail(to: ENV.fetch('FEEDBACK_ADDRESS', ''), subject: 'Feedback from miniCAST')
  end
end