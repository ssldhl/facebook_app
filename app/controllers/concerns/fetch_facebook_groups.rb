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
end