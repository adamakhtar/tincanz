class CreateTincanzReceipts < ActiveRecord::Migration
  def change
    create_table :tincanz_receipts do |t|
      t.integer :message_id
      t.integer :recipient_id

      t.timestamps
    end

    add_index :tincanz_receipts, :message_id
    add_index :tincanz_receipts, :recipient_id
  end
end
