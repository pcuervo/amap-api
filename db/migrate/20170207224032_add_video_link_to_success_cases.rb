class AddVideoLinkToSuccessCases < ActiveRecord::Migration[5.0]
  def change
    add_column :success_cases, :video_url, :string
  end
end
