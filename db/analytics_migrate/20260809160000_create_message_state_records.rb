class CreateMessageStateRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :message_records, id: :string, if_not_exists: true do |t|
      t.string :chat_id
      t.text :content
      t.string :sender_id
      t.string :receiver_id
      t.datetime :created_at
    end
  end
end
