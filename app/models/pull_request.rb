class PullRequest < ActiveRecord::Base
  unloadable
  belongs_to :issue
  has_many :pr_comments
end
