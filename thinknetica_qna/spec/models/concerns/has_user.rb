# frozen_string_literal: true
require 'rails_helper'

shared_examples_for 'has_user' do
  subject { create(described_class.to_s.underscore.to_sym) }
  context 'validates relationships' do
    it 'should belong to user' do
      subject.should belong_to(:user)
    end
  end
  it { subject.should validate_presence_of(:user_id) }
end
