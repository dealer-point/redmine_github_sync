class PullRequest < ActiveRecord::Base
  unloadable
  belongs_to :issue
end
