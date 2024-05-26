# frozen_string_literal: true

class AuthorizationsController < ApplicationController
  before_action :find_user, :find_auth, only: %i[create]

  def new
    @user = User.new
  end

  def create
    unless @user
      password = Devise.friendly_token[0,20]
      @user = User.create!(email: params[:email], password: password, password_confirmation: password)
    end

    unless @authorization
      auth = OmniAuth::AuthHash.new(auth_params)
      @authorization = @user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
    end

    AuthorizationMailer.send_confirmation_token(@authorization).deliver_now
    flash[:notice] = 'Check your email!'
    redirect_to root_path
  end

  def email_confirmation
    authorization = Authorization.find_by(confirmation_token: params[:confirmation_token])
    if authorization
      authorization.confirm!
      sign_in authorization.user
      flash[:notice] = 'Your email confirmed! You are logged in!'
    end
    redirect_to root_path
  end

  private

  def auth_params
    params.permit(:uid, :provider, :email)
  end

  def find_user
    @user = User.find_by(email: auth_params[:email])
  end

  def find_auth
    @authorization = Authorization.find_by(uid: auth_params[:uid], provider: auth_params[:provider])
  end
end
