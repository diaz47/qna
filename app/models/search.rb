class Search < ApplicationRecord
  SOURCES = %w(Everyware Comments Questions Answers)

  def self.find(source, query)
    request = ThinkingSphinx::Query.escape(query)
    return [] if !SOURCES.include?(source) || request.blank?

    source == 'Everyware' ? ThinkingSphinx.search(request) : source.classify.constantize.search(request)
  end
end
