# frozen_string_literal: true
require 'rails_helper'

shared_examples_for 'attachable' do
  let(:model) { create(described_class.to_s.underscore.to_sym) }
  context 'validates relationships' do
    it 'should have many attachments' do
      model.should have_many(:attachments)
    end
  end
  it { model.should accept_nested_attributes_for(:attachments).allow_destroy(true) }
end

describe Question do
  it_should_behave_like 'attachable'
end

describe Answer do
  it_should_behave_like 'attachable'
end
