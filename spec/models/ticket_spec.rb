require 'rails_helper'

RSpec.describe Ticket, type: :model do

  let(:ticket){ build(:ticket)}
  let(:ticket_with_org){ build(:ticket, :with_org)}

  let(:open_ticket){ create(:ticket, :open) }
  let(:closed_ticket){ create(:ticket, :closed) }
  let(:open_with_org){ create(:ticket, :open, :with_org) }
  let(:closed_with_org){ create(:ticket, :closed, :with_org) }

  describe 'attributes' do
    specify{ expect(ticket).to respond_to(:name) }
    specify{ expect(ticket).to respond_to(:description) }
    specify{ expect(ticket).to respond_to(:phone) }
    specify{ expect(ticket).to respond_to(:closed) }
    specify{ expect(ticket).to respond_to(:closed_at) }
  end

  describe 'relationships' do
    it { should belong_to(:region) }
    it { should belong_to(:resource_category) }
    it { should belong_to(:organization) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:region_id) }
    it { should validate_presence_of(:resource_category_id) }
    it { should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create) }
    it { should validate_length_of(:description).is_at_most(1020).on(:create) }
    #it { should validate(:phone).to be_phony_plausible }
  end

  # TODO: Add scope tests

  describe '#open' do
    it 'gets only open tickets without an organization' do
      open_tickets = Ticket.open

      expect(open_tickets).to include(open_ticket)
      expect(open_tickets).not_to include(closed_ticket, open_with_org, closed_with_org)
    end

    # it 'gets only open tickets with a particular organization' do
    #   ticket = Ticket.organization(1)
    #   expect(ticket).to eq(ticket_with_org)
    #   expect(ticket).to eq(closed_ticket_with_org)

    #   ticket = Ticket.organization
      
    #   open_tickets = Ticket.open

    #   expect(open_tickets).to include(open_ticket)
    #   #expect(open_tickets).not_to include(closed_ticket)
    #   expect(open_tickets).not_to include(closed_ticket, open_with_org, closed_with_org)
    # end
  end

  describe '#to_s' do
    let(:ticket){ build(:ticket, id: 10)}
    it 'has a string representation that is "Ticket id"' do
      expect(ticket.to_s).to eq('Ticket 10')
    end
  end

  describe '#open' do
    it 'gets the oposite of the closed property' do
      ticket.closed = false
      expect(ticket).to be_open
    end
  end
  
  describe '#captured' do
    it 'ticket is not captured by default' do
      expect(ticket).to_not be_captured
    end

    it 'ticket is captured if it has an organization' do
      expect(ticket_with_org).to be_captured
    end
  end
	
end
