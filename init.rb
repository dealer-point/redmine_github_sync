Redmine::Plugin.register :redmine_github_sync do
  name ' Redmine plugin for github synchronization'
  author 'LLC DealerPoint'
  description ' Redmine plugin for github synchronization'
  version '0.0.1'
  url 'https://github.com/dealer-point/redmine_github_sync'
  author_url 'https://github.com/dealer-point'

  require_dependency 'pulls_hook_listener'
end
