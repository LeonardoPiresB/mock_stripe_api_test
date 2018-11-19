Rails.application.routes.draw do
  resources :produtos
  match 'produtos/:id/pay' => "produtos#pay_produto", via: :post, as: :pay_produto
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
