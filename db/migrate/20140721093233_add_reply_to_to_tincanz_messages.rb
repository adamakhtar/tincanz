class AddReplyToToTincanzMessages < ActiveRecord::Migration
  def change
    add_column :tincanz_messages, :reply_to_id, :integer
  end
end 
