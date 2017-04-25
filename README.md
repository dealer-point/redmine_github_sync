# Redmine plugin for github synchronization
  Plugin for synchronization redmine and GitHub using webhooks. 
  The branch must have a name like some_prefix_XXX_some_note, where XXX its id of the redmine issue
***

# Install
  1. `cd plugins`
  2. `git clone git@github.com:dealer-point/redmine_github_sync.git`
  3. `bundle exec rake redmine:plugins:migrate`
  4. Enable the plugin in the plugins settings
  5. Go to the GitHub, open settings of the project, select tab 'webhooks' and set url to your server to payload controller with ".json" (for example www.redmine.com/payload.json)
  6. Choose events Pull request and Pull request review comment

## Connect old pull requests
#### For connect your old pull request you should: 
  - get github token. 
  For it go to your GitHub profile settings, select Personal access tokens in the left menu, choose 'repo' checkbox, fill in the description and put Generate token
  - run task:
 `bundle exec rake redmine:redmine_github_sync[owner,repo,token]`
Where owner it is a owner of the repository, repo it is a name of the repository and token - your personal access token.
For example 
`bundle exec rake redmine:redmine_github_sync['my-profile','my-repository','example7qac3f045x85d55b199q89101b4bc33dv']`