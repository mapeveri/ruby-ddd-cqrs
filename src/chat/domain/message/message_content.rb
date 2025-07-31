class Chat::Domain::Message::MessageContent
  attr_reader :value

  MAX_LENGTH = 2500

  def initialize(value)
    @value = value.freeze
    freeze
  end

  def self.of(value)
    raise ArgumentError, 'Message content cannot be nil' if value.nil?
    raise ArgumentError, 'Message content cannot be blank' if value.strip.empty?
    raise ArgumentError, "Message content exceeds #{MAX_LENGTH} characters" if value.length > MAX_LENGTH
    new(value)
  end

  def self.from_primitives(value)
    new(value)
  end

  def ==(other)
    other.is_a?(self.class) && value == other.value
  end

  def to_s
    value
  end
end
