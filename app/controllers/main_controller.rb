class MainController < ApplicationController
  before_action :authenticate_user!, :subscribed, :authenticated
  include FetchFacebookGroups

  def index
  end

  def search
    oauth_access_token = Authentication.find_by_user_id(current_user.id).token
    profile = Koala::Facebook::API.new(oauth_access_token)
    @search_result = search_groups(profile, params[:search_criteria])
    respond_to do |format|
      if @search_result == 'error'
        format.js { render 'main/search_error'}
      else
        format.js {}
      end
    end
  end

  def user_names
    oauth_access_token = Authentication.find_by_user_id(current_user.id).token
    profile = Koala::Facebook::API.new(oauth_access_token)
    members = get_members(params[:group_id], profile)
    user_names = resolve_user_names(profile,members)
    respond_to do |format|
      format.csv { send_data convert_to_csv(user_names) }
    end
  end

  private
  def convert_to_csv(user_names)
    CSV.generate do |csv|
      csv << user_names
    end
  end
end
