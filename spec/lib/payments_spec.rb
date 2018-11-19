require File.expand_path(File.dirname(__FILE__) + '/../../lib/payments')
require 'spec_helper'

describe Pagamento do

	let(:pagador) { described_class.new }

	it "Teste Exemplo de API Stripe" do
		expect(pagador.create_default_customer_if_not_exists).to eq(true)
	end

	it "Token invalido para pagamento" do 
		expect(pagador.pay_required_produto(999,"token_teste")).to eq(false)
		expect(pagador.get_last_error.class).to eq(Stripe::InvalidRequestError)
	end
	
end