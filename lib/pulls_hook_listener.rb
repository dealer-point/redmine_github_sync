class PollsHookListener < Redmine::Hook::ViewListener
  # def view_projects_show_left(context = {})
  #   return content_tag("p", "Custom content added to the left")
  # end

  # render_on :view_issues_show_description_bottom, :partial => "pull_requests/index"
  render_on :view_issues_show_description_bottom, :partial => 'pull_requests/items'
  # def view_issues_show_description_bottom(context = {})
  #   # return content_tag("p", "Custom content added to the right12")
  #   return '<hr><p><strong>Pull Requests</strong></p>'.html_safe
  # end

end
