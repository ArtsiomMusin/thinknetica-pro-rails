require 'rails_helper'

RSpec.describe Answer, type: :model do
  it 'validates presence of body' do
    expect(Answer.new).to_not be_valid
  end

  it { should belong_to(:question) }
end
