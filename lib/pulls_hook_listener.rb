class PollsHookListener < Redmine::Hook::ViewListener

  render_on :view_issues_show_description_bottom, :partial => 'pull_requests/items'

  def view_layouts_base_html_head(context = {})
    stylesheet_link_tag 'redmine_github.css', :plugin => 'redmine_github_sync'
  end

end
