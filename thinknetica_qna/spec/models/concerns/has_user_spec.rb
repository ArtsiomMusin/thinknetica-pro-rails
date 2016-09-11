# frozen_string_literal: true
require 'rails_helper'

shared_examples_for 'has_user' do
  let(:model) { create(described_class.to_s.underscore.to_sym) }
  context 'validates relationships' do
    it 'should belong to user' do
      model.should belong_to(:user)
    end
  end
  it { model.should validate_presence_of(:user_id) }
end

describe Question do
  it_should_behave_like 'has_user'
end

describe Answer do
  it_should_behave_like 'has_user'
end

describe Vote do
  it_should_behave_like 'has_user'
end
