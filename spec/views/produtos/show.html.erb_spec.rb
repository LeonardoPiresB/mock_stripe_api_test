require 'spec_helper'

describe 'produtos/show.html.erb' do
	it 'displays product details correctly' do
		prod = Produto.create descricao: "Produto 1", preco_unitario: 3.78, quantidade: 4, esta_pago: true
		assign(:produto, prod)

		render

		rendered.should include('<b class="pago">Pago</b>')
		
	end
end