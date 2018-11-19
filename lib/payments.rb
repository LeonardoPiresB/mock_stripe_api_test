require 'stripe'

class Pagamento	

	def initialize
		#Chave de Teste
		Stripe.api_key = "sk_test_8JBpUoA9PthFfvbbnCx5Hd2u"
	end

	def get_last_error
		return @last_error
	end

	def get_customer_info
		map = nil
		execute_stripe_request do 
			customers = Stripe::Customer.list(limit: 1)
			map = customers.first
		end
		return map
	end

	def create_default_customer_if_not_exists
		result = false
		execute_stripe_request do 
			customers = Stripe::Customer.list(limit: 1)
			print_message "Customer List: #{customers.inspect}, data empty? #{customers["data"].empty?}"
			customer = nil
			if customers["data"].empty?
				customer = Stripe::Customer.create(
					description: "Example Customer for test blumpa",
					email: "teste@teste.com.br",
					source: "tok_mastercard",
					shipping: nil
				)
				print_message "Customer Create: #{customer.inspect}"
			end			
			result = true
		end
		return result
	end

	def pay_required_produto(valor, token)
		result = false
		execute_stripe_request do 
			customers = Stripe::Customer.list(limit: 1)
			customer = nil
			customer = customers["data"].first unless customer			
			charge_created = Stripe::Charge.create(
				:amount => valor,
				:currency => "usd",
				:source => token, # obtained with Stripe.js
				:description => "Cobrar por Cliente Teste"
				# :customer => customer["id"]
			)
			print_message "Charge Create: #{charge_created.inspect}"
			result = true
		end
		return result
	end

	private

	def print_message(data, type=nil)
		if Object.const_defined? "Rails"
			log_type = :info
			log_type = type if type
			Rails.logger.send log_type, data
		else
			puts data
		end
	end

	def execute_stripe_request
		begin
			print_message "Executando Requisição Stripe..."
			yield
			# Use Stripe's library to make requests...
		rescue Stripe::CardError => e
			# Since it's a decline, Stripe::CardError will be caught
			@last_error = e
			print_message "ERRO durante Requisição Stripe..."
			body = e.json_body
			err  = body[:error]

			print_message "Status is: #{e.http_status}", :error
			print_message "Type is: #{err[:type]}", :error
			print_message "Charge ID is: #{err[:charge]}", :error
			print_message "Code is: #{err[:code]}", :error if err[:code]
			print_message "Decline code is: #{err[:decline_code]}", :error if err[:decline_code]
			print_message "Param is: #{err[:param]}", :error if err[:param]
			print_message "Message is: #{err[:message]}", :error if err[:message]
		
		rescue => e
			@last_error = e
			print_message "#{e.class}: #{e.message}", :error
			# Something else happened, completely unrelated to Stripe
		end
	end

end