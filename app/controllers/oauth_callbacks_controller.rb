# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :find_auth, :find_user, only: %i[github vkontakte]

  def github
    processing('GitHub')
  end

  def vkontakte
    if @auth && !@user&.email_confirmed?(@auth)
      redirect_to new_authorization_path(uid: @auth.uid, provider: @auth.provider)
    else
      processing('Vkontakte')
    end
  end

  private

  def find_auth
    @auth = request.env['omniauth.auth']
  end

  def find_user
    @user = User.find_for_oauth(@auth)
  end

  def processing(name)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: name) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end