class UserIdMother
  def self.create(value)
    Chat::Domain::User::UserId.of(value)
  end

  def self.random
    Chat::Domain::User::UserId.of(SecureRandom.uuid)
  end
end
