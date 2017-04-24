# Redmine plugin for github synchronization
  Plugin for synchronization redmine and GitHub using webhooks. 
  The branch must have a name like some_prefix_XXX_some_note, where XXX its id of the redmine issue
***

# Install
  1. cd plugins
  2. git clone git@github.com:dealer-point/redmine_github_sync.git
  3. Run "bundle exec rake redmine:plugins:migrate"
  4. Go to the GitHub, open settings of the project, select tab 'webhooks' and set url to your server to payload controller with ".json" (for example www.redmine.com/payload.json)
  5. Choose events Pull request and Pull request review comment

# Connect old pull requests
For connect your old pull request you shoud: 
  - get github token
  - go to plugin settings in the redmine 
  - specify token, owner and name of your repository
  - run task:
 `bundle exec rake redmine:redmine_github_sync`