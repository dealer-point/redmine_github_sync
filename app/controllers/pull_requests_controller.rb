class PullRequestsController < ApplicationController
  require 'json'
  unloadable

  def index
    @polls = PullRequest.all
  end

  def hooks
    pull_request_params =
      JSON.parse(hook_params[:payload])['pull_request']
          .slice('url', 'title', 'state', 'locked')
    pr = {}
    if pull_request_params
      pr = PullRequest.new(pull_request_params)
      pr.save
    end
    render json: {object: pr}
  end

  def get_hooks
    render text: params.to_json
  end

  private

  def hook_params
    params.permit(:payload)
  end
end
