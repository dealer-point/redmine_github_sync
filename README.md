# Redmine plugin for github synchronization
  Plugin for synchronization redmine and GitHub using webhooks. 
  The branch must have a name like some_prefix_XXX_some_note, where XXX its id of the redmine issue
  

# Install
  1. Put it to ./plugins
	2. Run "bundle exec rake redmine:plugins:migrate".
	3. Go to the GitHub, open settings of the project, select tab 'webhooks' and set url to your server to payload controller with ".json" (for example www.redmine.com/payload.json)

You can run rake task bundle exec rake redmine:redmine_github_sync for connect your old pull request, but early you shoud get github token and specify data in the plagin settings
