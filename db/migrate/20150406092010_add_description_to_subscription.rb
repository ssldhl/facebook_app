class AddDescriptionToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :description, :string
  end
end
