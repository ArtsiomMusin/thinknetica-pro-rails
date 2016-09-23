require 'rails_helper'
require_relative 'concerns/has_user'

RSpec.describe Authorization, type: :model do
  it { should validate_presence_of(:provider) }
  it { should validate_presence_of(:uid) }
  
  context 'concern checks' do
    it_behaves_like 'has_user'
  end
end
