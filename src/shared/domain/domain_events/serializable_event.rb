module Shared::Domain::DomainEvents::SerializableEvent
  def to_h
    instance_variables.each_with_object({}) do |var, hash|
      key = var.to_s.delete("@")
      hash[key] = instance_variable_get(var)
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def from_h(hash)
      new(**hash.transform_keys(&:to_sym))
    end
  end
end
