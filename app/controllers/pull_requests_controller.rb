class PullRequestsController < ApplicationController
  before_action :require_enable
  require 'json'
  unloadable

  def index
    @polls = PullRequest.all
  end

  def hooks
    issue = issue_by_number
    if issue.present?
      pr = PullRequest.find_by(github_id: request_params['github_id'])
      if pr.present?
        pr.update_attributes(request_params.merge('issue_id'=> issue.id))
      else
        pr = PullRequest.new(request_params)
        pr.issue = issue
        pr.save
      end
      update_comments(pr.id, action_params) if comment_params && action_params
      render json: { object: pr }
    else
      render json: { message: "don\'t have issue with this number" }
    end
  end

  private

  def issue_by_number
    return nil unless request_params
    title = request_params['title']
    title_math = /\d+/.match(title)
    @issue_number = if title_math
      title_math[0]
    else
      nil
    end

    Issue.find_by_id(@issue_number)
  end

  def action_params
    hook_params = params.permit(:payload)
    JSON.parse(hook_params[:payload])['action']
  end

  def request_params
    hook_params = params.permit(:payload)
    pull_request = JSON.parse(hook_params[:payload])['pull_request']
    pull_request['github_id'] = pull_request['id']
    pull_request.slice('html_url', 'title', 'state', 'locked', 'github_id',
                       'created_at', 'updated_at', 'number')
  end

  def comment_params
    hook_params = params.permit(:payload)
    comment = JSON.parse(hook_params[:payload])['comment']
    comment['github_id'] = comment['id']
    comment['author'] = comment['user']['login']
    comment.slice('html_url', 'diff_hunk', 'body', 'author', 'github_id',
                  'created_at', 'updated_at', 'path')
  end

  def create_journal(prc)
    num_string = /,(\d+)/.match(prc.diff_hunk)[1]
    if prc.journal.present?
      journal_params =
        { notes: "_/#{prc.path}_:#{num_string}\n"\
                 "#{prc.author}: #{prc.body}"}
      prc.journal.update_attributes(journal_params)
      prc.journal
    else
      journal_params =
        { journalized_type: "Issue",
          notes: "_/#{prc.path}_:#{num_string}\n"\
                 "#{prc.author}: #{prc.body}",
          journalized_id: @issue_number }
      journal = Journal.new(journal_params)
      journal.save
      journal
    end
  end

  def update_comments(pr_id, action)
    case action
    when 'created'
      prc = PrComment.new(comment_params)
      prc.pull_request = PullRequest.find(pr_id)
      journal = create_journal(prc)
      prc.journal = journal
      prc.save
    when 'edited'
      prc = PrComment.find_by(github_id: comment_params['github_id'])
      if prc.present?
        prc.update_attributes(comment_params.merge('pull_request_id'=> pr_id))
        create_journal(prc)
      else
        update_comments(pr_id, 'created')
      end
    when 'deleted'
      prc = PrComment.find_by(github_id: comment_params['github_id'])
      prc.journal.destroy if prc.journal.present?
      prc.destroy if prc.present?
    end
  end

  def require_enable
    unless Setting.plugin_redmine_github_sync['enable_pull_requests'].eql?('true')
      answer = {}
      answer[:error] = 'plagin is disabled'
      render json: answer.as_json, status: 503
    end
  end
end
