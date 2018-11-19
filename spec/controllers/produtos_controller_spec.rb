require 'spec_helper'
require 'rails_helper'

describe ProdutosController, type: :controller do

	describe "GET index" do

		it "HTTP 200 OK" do
			get :index
			expect(response.status).to eq(200)
		end		
		
	end

	describe "POST" do
		it "Criacao Produto via Pagina" do
			post :create, params: { produto: { descricao: "Produto 1", preco_unitario: 3.78, quantidade: 4 } }
			expect(response.content_type).to eq "text/html"
			expect(response.status).to eq(302)
		end

		it "Criacao Produto via requisição JSON" do
			post :create, params: { produto: { descricao: "Produto 1", preco_unitario: 3.78, quantidade: 4 }, format: :json }
			expect(response.content_type).to eq "application/json"
			expect(response.status).to eq(201)
		end

	end

	describe "PUT" do
		it "Atualização de Produto via Pagina" do
			post :create, params: { produto: { descricao: "Produto 1", preco_unitario: 3.78, quantidade: 4 } }
			put :update, params: {id: Produto.first.id, produto: { descricao: "Produto 1", preco_unitario: 3.78, quantidade: 8 } }
			expect(response.status).to eq(302)
			expect(response.redirect_url).to end_with("/produtos/1")
		end

		it "Atualização Produto via requisição JSON" do
			post :create, params: { produto: { descricao: "Produto 1", preco_unitario: 3.78, quantidade: 4 }, format: :json }
			patch :update, params: {id: Produto.first.id, produto: { descricao: "Produto 1", preco_unitario: 3.78, quantidade: 8 }, format: :json }
			expect(response.content_type).to eq "application/json"
			expect(response.status).to eq(200)
		end
	end

	describe "DELETE" do

		it "Remoção de Produto via requisição JSON" do
			post :create, params: { produto: { descricao: "Produto 1", preco_unitario: 3.78, quantidade: 4 }, format: :json }
			delete :destroy, params: {id: Produto.first.id, format: :json }
			expect(response.status).to eq(204)
		end

	end

	describe "Pagar Produto" do

		it "Produto já PAGO: Página" do
			post :create, params: { produto: { descricao: "Produto 1", preco_unitario: 3.78, quantidade: 4, esta_pago: true } }
			post :pay_produto, params: {id: Produto.first.id }
			expect(response.content_type).to eq "text/html"
			expect(response.status).to eq(302)
			expect(response.redirect_url).to end_with("/produtos/1")
		end

	end

end