class CreateTincanzMessages < ActiveRecord::Migration
  def change
    create_table :tincanz_messages do |t|
      t.text :content
      t.integer :conversation_id
      t.integer :user_id

      t.timestamps
    end

    add_index :tincanz_messages, :user_id
    add_index :tincanz_messages, :conversation_id
  end
end
