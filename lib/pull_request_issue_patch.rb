require_dependency 'issue'

module PullRequestIssuePatch
  def self.included(base)
    base.extend(ClassMethods)
    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      has_many :pull_requests
    end
  end

  module ClassMethods
  end
end

# Add module to Issue
Issue.send(:include, PullRequestIssuePatch)
