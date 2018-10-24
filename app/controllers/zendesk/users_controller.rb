class Zendesk::UsersController < ApplicationController
  def search_results
    @search_param = params[:search]
    get_zendesk_users
  end

  def get_zendesk_users
    @users_found = Zendesk.client.users.search(:query => @search_param, :include => :identities).map do |user|
      {
        "id" => user.id,
        "name" => user.name,
        "email" => user.email,
        "phone" => list_phone_numbers(user)
      }
    end
  end

  def list_phone_numbers(user)
    numbers = user.identities.map{ |id| id.value if id.type == 'phone_number' }.compact
    numbers << user.phone unless numbers.include?(user.phone)
    numbers.join(', ')
  end
end