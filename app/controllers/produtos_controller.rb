class ProdutosController < ApplicationController
  require 'payments'
  before_action :set_produto, only: [:show, :edit, :update, :destroy, :pay_produto]  

  # GET /produtos
  # GET /produtos.json
  def index
    @produtos = Produto.all
  end

  # GET /produtos/1
  # GET /produtos/1.json
  def show
  end

  # GET /produtos/new
  def new
    @produto = Produto.new
  end

  # GET /produtos/1/edit
  def edit
  end

  # POST /produtos
  # POST /produtos.json
  def create
    @produto = Produto.new(produto_params)

    respond_to do |format|
      if @produto.save
        format.html { redirect_to @produto, notice: 'Produto was successfully created.' }
        format.json { render :show, status: :created, location: @produto }
      else
        format.html { render :new }
        format.json { render json: @produto.errors, status: :unprocessable_entity }
      end
    end
  end

  def pay_produto
    if @produto.esta_pago
      respond_to do |format|
        format.html { redirect_to @produto, notice: 'Produto has already been paid.' }
        format.json { render :show, location: @produto }
      end
    end
    p = Pagamento.new
    p.create_default_customer_if_not_exists
    token_credit_card = params[:stripeToken]
    valor = 0
    valor = @produto.preco_unitario * @produto.quantidade
    valor *= 100
    result = p.pay_required_produto valor.to_i, token_credit_card
    logger.info "Result: #{result.inspect}"
    customer_info_map = p.get_customer_info
    if result
      @produto.update(esta_pago: true)
      PaymentMailer.with(produto: @produto, email: customer_info_map["email"])
        .send_product_paid_notification.deliver_later
      respond_to do |format|
        format.html { redirect_to @produto, notice: 'Produto has been successfully paid.' }
        format.json { render :show, location: @produto }
      end
    else
      PaymentMailer.with(produto: @produto, stripe_exception: p.get_last_error, email: customer_info_map["email"])
        .send_product_payment_error_notification.deliver_later
      respond_to do |format|
        format.html { redirect_to @produto, notice: 'Produto cannot be paid.' }
        format.json { render :show, location: @produto }
      end
    end
  end

  # PATCH/PUT /produtos/1
  # PATCH/PUT /produtos/1.json
  def update
    respond_to do |format|
      if @produto.update(produto_params)
        format.html { redirect_to @produto, notice: 'Produto was successfully updated.' }
        format.json { render :show, status: :ok, location: @produto }
      else
        format.html { render :edit }
        format.json { render json: @produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produtos/1
  # DELETE /produtos/1.json
  def destroy
    @produto.destroy
    respond_to do |format|
      format.html { redirect_to produtos_url, notice: 'Produto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_produto
      @produto = Produto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def produto_params
      params.require(:produto).permit(:descricao, :preco_unitario, :quantidade)
    end
end
