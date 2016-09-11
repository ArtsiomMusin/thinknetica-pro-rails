# frozen_string_literal: true
require 'rails_helper'

shared_examples_for 'has_votes' do
  let(:model) { create(described_class.to_s.underscore.to_sym) }
  context 'validates relationships' do
    it 'should have many votes' do
      model.should have_many(:votes)
    end
  end
end

describe Question do
  it_should_behave_like 'has_votes'
end

describe Answer do
  it_should_behave_like 'has_votes'
end

describe User do
  it_should_behave_like 'has_votes'
end
