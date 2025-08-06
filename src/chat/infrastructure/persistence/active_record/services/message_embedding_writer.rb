class Chat::Infrastructure::Persistence::ActiveRecord::Services::MessageEmbeddingWriter
  def update_embedding(id, embedding)
    MessageRecord.where(id: id).update(embedding: embedding)
  end
end
