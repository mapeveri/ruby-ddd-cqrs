require 'ostruct'

class QueryBusMock < Shared::Domain::Bus::QueryBus
  attr_reader :response

  def initialize
    @response = nil
  end

  def add(response)
    @response = response
  end

  def clear
    @response = nil
  end

  def ask(query)
    OpenStruct.new(content: @response)
  end
end
