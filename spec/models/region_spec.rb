require 'rails_helper'

RSpec.describe Region, type: :model do

  let(:region){ build(:region, name: 'FAKE') }

  describe 'attributes' do
    specify{ expect(region).to respond_to(:name) }
  end

  describe 'relationships' do
    it { should have_many(:tickets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe '#to_s' do
    it 'has a string representation that is the name' do
      expect(region.to_s).to eq('FAKE')
    end
  end

  describe '::unspecified' do
    it 'creates a new Unspecified region when one does not exist' do
      expect(Region.where(name: 'Unspecified')).to be_empty
      expect{ Region.unspecified }.to change { Region.count }.by(1)
    end
    it 'does not create a new Unspecified region when one already exists' do
      create(:region, :unspecified)
      expect{ Region.unspecified }.to_not change { Region.count }
    end
    it 'returns a region with the name Unspecified' do
      expect(Region.unspecified.name).to eq('Unspecified')
    end
  end

end
