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
    @invoice[:status] = 0
    @invoice[:customer_address] = ''
    @invoice[:customer_contact] = ''
    @invoice[:company_address] = ''
    @invoice[:company_contact] = '' 
    @invoice[:invoice_amount] = 0
    if @invoice.save
      flash[:success] = "New customer successfully added."
      redirect_to action:'index'
    else
      render 'new'
    end
  end
  
  def destroy
    
  end
  
  
  def show
  end
  
  def edit
    
  end
  
end
