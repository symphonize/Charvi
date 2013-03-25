class InvoicesController < ApplicationController
  
  before_filter :signed_in_user
  
  def index 
    @invoices = Invoice.joins(:customer).where('invoices.company_token' =>  company_token)
    
  end
  
  def new
    @invoice = Invoice.new
    @customers = Customer.where(company_token: company_token)
  end
  
  def create
    @invoice = Invoice.new(params[:invoice])
    
    
    @invoice[:company_token] = company_token
    @invoice[:status_code] = 'Created'
    @invoice[:customer_address] = @invoice.customer.address1
    @invoice[:customer_contact] = ''
    @invoice[:company_address] = ''
    @invoice[:company_contact] = '' 
    @invoice[:invoice_amount] = 0
    if @invoice.save
      flash[:success] = "New customer successfully added."
      
      redirect_to invoice_edit_path(@invoice.id)
    else
      @customers = Customer.where(company_token: company_token)
      render 'new'
    end
  end
  
  def destroy
    
  end
  
  
  def show
  end
  
  def edit
    @invoice = Invoice.find_by_id_and_company_token(params[:id], company_token)
    @customers = Customer.where(company_token: company_token)
  end
  
end
