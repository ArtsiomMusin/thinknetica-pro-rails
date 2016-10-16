require 'rails_helper'
require_relative 'concerns/has_user'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  
  context 'concern checks' do
    it_behaves_like 'has_user'
  end
end
