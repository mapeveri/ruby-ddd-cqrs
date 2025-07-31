require 'rails_helper'

RSpec.describe Chat::Domain::Message::MessageContent, type: :value_object do
  describe '.of' do
    it 'creates a valid MessageContent with normal string' do
      content = described_class.of("hello")
      expect(content.value).to eq("hello")
    end

    it 'raises error when content is nil' do
      expect { 
        described_class.of(nil)
      }.to raise_error(ArgumentError)
    end

    it 'raises error when content is blank' do
      expect {
        described_class.of('   ')
      }.to raise_error(ArgumentError)
    end

    it 'raises error when content exceeds max length' do
      long_content = 'a' * 2501
      expect {
        described_class.of(long_content)
      }.to raise_error(ArgumentError)
    end
  end
end
