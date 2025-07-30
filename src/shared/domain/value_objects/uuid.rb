class Shared::Domain::ValueObjects::Uuid
  private_class_method :new
  attr_reader :value

  def self.of(value)
    raise ArgumentError, "#{name} cannot be nil" if value.nil?
    raise ArgumentError, "#{name} has an invalid format" unless valid_uuid?(value)

    new(value)
  end

  def self.from_primitives(value)
    new(value)
  end

  def self.random
    new(UUIDTools::UUID.random_create.to_s)
  end

  def ==(other)
    other.is_a?(self.class) && value == other.value
  end

  def to_s
    value
  end

  private

  def initialize(value)
    @value = value.freeze
    freeze
  end

  def self.valid_uuid?(val)
    UUIDTools::UUID.parse(val)
    true
  rescue ArgumentError
    false
  end
end
