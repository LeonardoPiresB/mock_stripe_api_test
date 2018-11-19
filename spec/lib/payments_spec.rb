require File.expand_path(File.dirname(__FILE__) + '/../../lib/payments')
require 'spec_helper'

describe Pagamento do

	let(:pagador) { described_class.new }

	it "Teste Exemplo de API Stripe" do 

		expect(pagador.create_default_customer_if_not_exists).to eq(true)

	end

	it "Token invalido para pagamento" do 


	end

	it "Necessita de um token válido" do
		expect {
			charge = Stripe::Charge.create(
				amount: 99,
				currency: 'usd',
				source: 'fake_card_token'
			)
		}.to raise_error(Stripe::InvalidRequestError, /token/i)
	end
	
end