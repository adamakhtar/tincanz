class CreateTincanzConversations < ActiveRecord::Migration
  def change
    create_table :tincanz_conversations do |t|
      t.string :subject
      t.integer :user_id

      t.timestamps
    end

    add_index :tincanz_conversations, :user_id
  end
end
