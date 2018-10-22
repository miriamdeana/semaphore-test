class Zendesk::UsersController < ApplicationController
  def search_results
    @search_param = params[:search]
    get_zendesk_users
  end

  def get_zendesk_users
    @users_found = Zendesk.client.users.search(:query => @search_param).map do |user|
      {
        "name" => user.name,
        "email" => user.email,
        "phone" => user.phone
      }
    end
  end
end