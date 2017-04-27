namespace :redmine do
  desc "GitHub synchronize"
  task :redmine_github_sync, [:owner, :repo, :token] => [:environment] do |t, args|
    owner = args[:owner]
    repo = args[:repo]
    token = args[:token]

    new_pulls = 0
    updates = 0
    errors = 0

    githubApi = GithubApi.new(owner, repo, token)
    puts "\nGetting pulls from #{owner}/#{repo}"
    pulls = githubApi.pulls
    puts "Count of pull requests(#{owner}/#{repo}): #{pulls.count}\n"
    pulls.each do |pull|
      params = request_params(pull)
      title = params['title']
      title_math = /\d+/.match(title)

      @issue_number = if title_math
        title_math[0]
      else
        nil
      end
      issue = @issue_number ? Issue.find_by(id: @issue_number) : nil
      pr = PullRequest.find_by(github_id: params['github_id'])

      message = if @issue_number.present?
        @issue_number
      else
        'Can\'t parse the number from ' + title
      end
      puts "Number issue from pull's title: #{message}\r"
      if pr.present? && issue.present?
        if pr.update_attributes(params.merge('issue_id'=> issue.id))
          updates += 1
        else
          errors += 1
        end
      elsif issue.present?
        pr = PullRequest.new(params)
        pr.issue = issue
        if pr.save
          new_pulls += 1
        else
          errors += 1
        end
      end
    end

    puts "\nFinish. Updated: #{updates}. "\
         "Added to projects: #{new_pulls}. Errors: #{errors}\n"
  end
end

def request_params(pull)
  pull_request = pull
  pull_request['github_id'] = pull_request['id']
  pull_request.slice('html_url', 'title', 'state', 'locked', 'github_id',
                     'created_at', 'updated_at', 'number')
end
