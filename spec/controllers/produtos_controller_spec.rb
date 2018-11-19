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
			expect(response.status).to eq(302) #FOUND Redirect
		end

		it "Criacao Produto via requisição JSON" do
			post :create, params: { produto: { descricao: "Produto 1", preco_unitario: 3.78, quantidade: 4 }, :format => :json }
			expect(response.content_type).to eq "application/json"
			expect(response.status).to eq(201) #HTTP Created
		end

	end

end