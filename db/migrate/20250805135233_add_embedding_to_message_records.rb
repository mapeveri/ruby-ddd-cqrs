class AddEmbeddingToMessageRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :message_records, :embedding, :json, null: true
  end
end
