class PullRequestsController < ApplicationController
  require 'json'
  unloadable

  def index
    @polls = PullRequest.all
  end

  def hooks
    pr = {}
    if request_params
      title = request_params['title']
      issue_number = /\d+/.match(title)[0]
      issue = issue_number ? Issue.find(issue_number) : nil
      pr = PullRequest.find_by(github_id: request_params['github_id'])
      if pr.present?
        pr.update_attributes(request_params.merge('issue_id'=> issue.id))
      else
        pr = PullRequest.new(request_params)
        pr.issue = issue
        pr.save
      end
    end
    render json: { object: pr }
  end

  def get_hooks
    render text: params.to_json
  end

  private

  def request_params
    hook_params = params.permit(:payload)
    pull_request = JSON.parse(hook_params[:payload])['pull_request']
    pull_request['github_id'] = pull_request['id']
    pull_request.slice('html_url', 'title', 'state', 'locked', 'github_id')
  end
end
