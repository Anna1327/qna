# frozen_string_literal: true

class AuthorizationMailer < ApplicationMailer
  def send_confirmation_token(authorization)
    @authorization = authorization
    mail(
      to: authorization.user.email,
      subject: 'Confirm your email'
    )
  end
end
