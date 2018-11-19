class PaymentMailer < ApplicationMailer
	default from: "teste@xyz.com.br"

	def send_product_paid_notification
		@produto = params[:produto]
		mail to: params[:email], subject: "Alerta de Produto Pago"
	end

	def send_product_payment_error_notification
		@produto = params[:produto]
		@exception_message = params[:stripe_exception]
		mail to: params[:email], subject: "Alerta de NÃO pagamento de Produto"
	end
end
