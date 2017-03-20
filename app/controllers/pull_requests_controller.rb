class PullRequestsController < ApplicationController
  require 'json'
  unloadable

  def index
    @polls = PullRequest.all
  end

  def hooks
    request_params =
      JSON.parse(hook_params[:payload])['pull_request']
    pr = {}
    title = request_params['title']
    issue_number = /\d+/.match(title)[0]
    if request_params
      pr =
        PullRequest
          .new(request_params.slice('html_url', 'title', 'state', 'locked'))
      pr.github_id = request_params['id']
      pr.issue = Issue.find(issue_number) if issue_number
      pr.save
    end
    render json: { object: pr }

  end

  def get_hooks
    render text: params.to_json
  end

  private

  def hook_params
    params.permit(:payload)
  end
end
