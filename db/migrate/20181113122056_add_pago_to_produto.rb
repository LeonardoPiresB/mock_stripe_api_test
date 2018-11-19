class AddPagoToProduto < ActiveRecord::Migration[5.2]
  def change
    add_column :produtos, :esta_pago, :boolean
  end
end
