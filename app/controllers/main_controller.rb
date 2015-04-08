class MainController < ApplicationController
  before_action :authenticate_user!, :subscribed, :authenticated

  def index
  end

  def search
    oauth_access_token = Authentication.find_by_user_id(current_user.id).token
    profile = Koala::Facebook::API.new(oauth_access_token)
    begin
      search_result = profile.graph_call('search?q='+params[:search_criteria]+'&type=group')
    rescue Exception => e
      puts e.message
    end

    puts "------------------"
    puts search_result
    puts "------------------"

=begin
    search_result.each do |result|
      puts '-----------------'
      puts result['id']
      puts '-----------------'
    end
=end

    begin
      member = profile.graph_call(search_result[0]['id']+'/members')
    rescue Exception => e
      puts e.message
    end

    begin
      user = profile.get_object(member[0]['id'])
    rescue Exception => e
      puts e.message
    end

    puts "user = #{user}"

    puts "user link = #{user['link']}"

    agent = Mechanize.new

    page = agent.get('https://www.facebook.com/')
    form = agent.page.forms.first

    form.email = ENV['FACEBOOK_EMAIL']
    form.pass = ENV['FACEBOOK_PASSWORD']

    form.submit

    page =  agent.get(user['link'])

    user_name =  page.uri.to_s.split('/').last

    puts "USER NAME === #{user_name}"

    puts "USER EMAIL === #{user_name}@facebook.com"


    render text:'ok'
  end
end
