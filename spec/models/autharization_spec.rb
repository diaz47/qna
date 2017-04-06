require 'rails_helper'

RSpec.describe Autharization, type: :model do
  it { should belong_to :user }
end
