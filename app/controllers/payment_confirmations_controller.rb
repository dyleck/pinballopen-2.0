class PaymentConfirmationsController < ApplicationController
  protect_from_forgery except: [:create]
  before_action :redirect_to_login_if_not_logged_in, except: [:create]
  before_action :redirect_to_root_if_not_admin, except: [:create]

  def create
    if validate_paypal_ipn(request.raw_post)
      if params[:payment_status] == "Completed"
        order = Order.find_by(id: params[:invoice])
        if order
          order.update_attribute(:payment_confirmed, true)
        end
      else
        render status: 500
      end
    end
  end

  def index
    @orders = Order.where(payment_type: "bank_transfer", payment_confirmed: [false, nil])
  end

  def update
    @order = Order.find_by(id: params[:id])
    if @order && @order.update_attribute(:payment_confirmed, true)
      UserMailer.payment_confirmed(@order).deliver_now
      respond_to do |format|
        format.js
      end
    end
  end

  private
    def validate_paypal_ipn(raw_post)
      uri = URI.parse("#{Rails.application.secrets.paypal_host}/cgi-bin/webscr")
      request_path = "#{uri.path}?cmd=_notify-validate"
      request = Net::HTTP::Post.new(request_path)
      request['Content-Length'] = "#{raw_post.size}"
      request['User-Agent'] = "PinballOpen2016 app"
      http = Net::HTTP.new(uri.host, uri.port)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true
      response = http.request(request, raw_post).body
      ["VERIFIED"].include?(response)
    end
end
