class GetUserEngagementQueryMother
  def self.create(user_id: SecureRandom.uuid)
    Analytics::Application::Queries::GetUserEngagementQuery.new(
      user_id: user_id
    )
  end

  def self.random
    create
  end

  def self.with_invalid_user_id
    create(user_id: '')
  end
end
