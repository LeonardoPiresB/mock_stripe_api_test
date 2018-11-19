class CreateProdutos < ActiveRecord::Migration[5.2]
  def change
    create_table :produtos do |t|
      t.string :descricao
      t.float :preco_unitario
      t.integer :quantidade

      t.timestamps
    end
  end
end
