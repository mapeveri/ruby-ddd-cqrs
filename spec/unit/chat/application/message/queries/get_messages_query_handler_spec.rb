require 'rails_helper'

RSpec.describe Chat::Application::Message::Queries::GetMessagesQueryHandler, type: :handler do
  let(:read_model) { GetMessagesReadModelMock.new }
  let(:handler) { described_class.new(get_messages_read_model: read_model) }

  after do
    read_model.clear
  end

  describe 'when #call is called with invalid values' do
    invalid_cases = {
      'chat_id' => :with_invalid_chat_id
    }

    invalid_cases.each do |field, method|
      it "should raise an error when #{field} is invalid" do
        invalid_query = GetMessagesQueryMother.send(method)

        expect {
          handler.call invalid_query
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'when a #call method is called' do
    before do
      read_model.add(MessageMother.random.to_h)
      read_model.add(MessageMother.random.to_h)
    end

    it 'should return the chat messages' do
      query = GetMessagesQueryMother.random

      result = handler.call query

      expect(result.messages.size).to eq(2)
    end
  end
end
