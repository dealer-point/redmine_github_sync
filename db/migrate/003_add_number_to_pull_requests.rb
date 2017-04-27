class AddNumberToPullRequests < ActiveRecord::Migration
  def change
    add_column :pull_requests, :number, :integer
  end
end
