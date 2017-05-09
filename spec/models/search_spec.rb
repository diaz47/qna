require 'rails_helper'

RSpec.describe Search, type: :model do
  describe 'Models' do
    %w(Questions Answers Comments).each do |source|
      it "call method search in #{source} if query is valid" do
        expect(source.classify.constantize).to receive(:search).with('query')
        Search.find("#{source}", 'query')
      end
      it "call not method search in #{source} if query is invalid" do
        expect(source.classify.constantize).to_not receive(:search).with('')
        Search.find("#{source}", '')
      end
    end
  end

  describe 'Everywhere' do
    it "call method search in ThinkingSphinx if query is valid" do
      expect(ThinkingSphinx).to receive(:search).with('query')
      Search.find("Everyware", 'query')
    end
    it "call not method search in ThinkingSphinx if query is invalid" do
      expect(ThinkingSphinx).to_not receive(:search).with('')
      Search.find("Everyware", '')
    end
  end

  it 'call not method search if wrong source model' do
    expect("User".classify.constantize).to_not receive(:search).with('query')
    Search.find("User", 'query')
  end
end
