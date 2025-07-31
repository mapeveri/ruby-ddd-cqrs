class CreateMessageRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :message_records, id: false do |t|
      t.string :id, primary_key: true, null: false
      t.string :sender_id
      t.string :receiver_id
      t.text :content
      t.datetime :created_at
    end
  end
end
