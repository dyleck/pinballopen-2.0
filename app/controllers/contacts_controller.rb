class ContactsController < ApplicationController
  def create
    UserMailer.contact(params[:contact][:email], params[:contact][:subject], params[:contact][:message]).deliver_now
    redirect_to root_path
  end
end
