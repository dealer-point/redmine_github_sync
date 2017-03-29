class CreatePrComments < ActiveRecord::Migration
  def change
    create_table :pr_comments do |t|
      t.integer :pull_request_id
      t.string :body
      t.string :html_url
      t.integer :github_id
      t.string :diff_hunk
      t.string :author
      t.datetime :created_at
      t.datetime :updated_at
      t.string :path
      t.integer :journal_id
    end
  end
end
