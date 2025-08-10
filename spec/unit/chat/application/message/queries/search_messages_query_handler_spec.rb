require 'rails_helper'

RSpec.describe Chat::Application::Message::Queries::SearchMessagesQueryHandler, type: :handler do
  let(:read_model) { SearchMessagesReadModelMock.new }
  let(:handler) { described_class.new(search_messages_read_model: read_model) }

  describe 'when #call is called with invalid values' do
    invalid_cases = {
      'chat_id' => :with_invalid_chat_id
    }

    invalid_cases.each do |field, method|
      it "should raise an error when #{field} is invalid" do
        invalid_query = SearchMessagesQueryMother.send(method)

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
      query = SearchMessagesQueryMother.random

      result = handler.call query

      expect(result.messages.size).to eq(2)
    end
  end
end
