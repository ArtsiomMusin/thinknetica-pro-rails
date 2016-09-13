# frozen_string_literal: true
require 'rails_helper'

shared_examples_for 'attachable' do
  subject { create(described_class.to_s.underscore.to_sym) }
  context 'validates relationships' do
    it 'should have many attachments' do
      subject.should have_many(:attachments)
    end
  end
  it { subject.should accept_nested_attributes_for(:attachments).allow_destroy(true) }
end
