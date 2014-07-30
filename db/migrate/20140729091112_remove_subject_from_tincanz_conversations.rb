class RemoveSubjectFromTincanzConversations < ActiveRecord::Migration
  def up
    remove_column :tincanz_conversations, :subject
  end

  def down
    add_column :tincanz_conversations, :subject, :string
  end
end
