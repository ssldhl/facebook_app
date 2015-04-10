module FetchFacebookGroups
  extend ActiveSupport::Concern

  def search_groups(profile, search_criteria)
    begin
      search_result = profile.graph_call('search?q='+search_criteria+'&type=group')
      all_result = []
      search_result.each do |result|
        all_result << result
      end
      new_page = search_result.next_page
      while new_page && new_page != []
        new_page.each do |result|
          all_result << result
        end
        new_page = new_page.next_page
      end
    rescue Exception => e
      logger.error "Facebook error: #{e.message}"
      all_result = 'error'
    end
    all_result
  end

  def get_members(selected_groups, profile)
    all_members = []
    final_members_id = []
    selected_groups.each_slice(50) do |groups|
      all_members << profile.batch {|batch_api| groups.each{|group| batch_api.graph_call(group+'/members')}}
    end
    all_members.each do |all_member|
      all_member.each do |member|
        if member && member != []
          member.each do |m|
            final_members_id << m['id']
          end
        end
      end
    end
    final_members_id.uniq
  end

  def resolve_user_names(profile, members)
    all_users = []
    final_user_link = []
    user_names = []
    members.each_slice(50) do |member|
      all_users << profile.batch {|batch_api| member.each{|m| batch_api.get_object(m)}}
    end

    all_users.each do |all_user|
      all_user.each do |user|
        if user && user != []
          final_user_link << user['link']
        end
      end
    end
    unique_user_links = final_user_link.uniq
    agent = Mechanize.new

    begin
      page = agent.get('https://www.facebook.com/')
      form = agent.page.forms.first
      form.email = ENV['FACEBOOK_EMAIL']
      form.pass = ENV['FACEBOOK_PASSWORD']

      form.submit

      page =  agent.get(unique_user_links[0])
    rescue Exception => e
      logger.error "Mechanize error: #{e.message}"
    end

    unique_user_links.each do |user_link|
      page =  agent.get(user_link)
      user_email = page.uri.to_s.split('/').last+'@facebook.com'
      puts user_email
      user_names << user_email
    end

    user_names
  end

end