class PrComment < ActiveRecord::Base
  unloadable
  belongs_to :pull_request
  belongs_to :journal
end
