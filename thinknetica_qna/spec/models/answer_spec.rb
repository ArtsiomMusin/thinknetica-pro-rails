# frozen_string_literal: true
require 'rails_helper'
require_relative 'concerns/votable'
require_relative 'concerns/has_user'
require_relative 'concerns/attachable'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:question_id) }

  describe '#make_best?' do
    let(:question) { create(:question) }
    before { create(:answer, question: question) }
    it 'sets the best answer' do
      question.answers.first.make_best
      expect(question.answers.first.best).to be true
    end
  end

  context 'concern checks' do
    it_behaves_like 'votable'
    it_behaves_like 'has_user'
    it_behaves_like 'attachable'
  end
end
