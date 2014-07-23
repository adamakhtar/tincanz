class AddReplyToIndexToMessages < ActiveRecord::Migration
  def change
    add_index :tincanz_messages, :reply_to_id
  end
end
