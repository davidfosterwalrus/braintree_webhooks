class AddObjectToWebhooks < ActiveRecord::Migration[6.0]
  def change
    add_column :webhooks, :object, :string
  end
end
