module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Lead Chicken Social Spy"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  #Returns the active class based on navigation links
  def active_navigation(current_page_params, current_page_name)
    current_page_action = current_page_params[:action]
    if current_page_action == current_page_name
      'active'
    else
      ''
    end
  end
end
