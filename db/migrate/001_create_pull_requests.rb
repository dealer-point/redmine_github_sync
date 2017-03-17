class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.string :url
      t.string :title
      t.string :state
      t.boolean :locked
    end
  end
end
