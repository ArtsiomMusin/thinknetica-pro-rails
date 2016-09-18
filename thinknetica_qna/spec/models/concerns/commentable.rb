# frozen_string_literal: true
require 'rails_helper'

shared_examples_for 'commentable' do
  subject { create(described_class.to_s.underscore.to_sym) }
  context 'relationships' do
    it 'should have many comments' do
      subject.should have_many(:comments)
    end
  end
end
