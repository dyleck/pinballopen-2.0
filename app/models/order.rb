class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_items, dependent: :destroy

  PAYMENT_TYPES = [ "bank_transfer", "paypal" ]
  PAYPAL_CERT_PEM = File.read("#{Rails.root}/app/certs/paypal_cert.pem")
  APP_CERT_PEM = File.read("#{Rails.root}/app/certs/app_cert.pem")
  APP_KEY_PEM = File.read("#{Rails.root}/app/certs/app_key.pem")

  validates :user, presence: true
  validates :payment_type, inclusion: PAYMENT_TYPES, allow_nil: true

  def recalc_local_prizes_of_items
    self.update_attribute :locale, I18n.locale
    sff = self.user.sff_validated
    self.order_items.each do |item|
      price = (sff && !item.product.sff_price.nil? && item.product.sff_price > 0) ?
          item.product.sff_price : item.product.price
      price = case I18n.locale
                when :en then (price / 4.4).to_i + 1
                when :pl then price
              end
      item.update_attribute :price, price
    end
  end

  def total_price
    self.order_items.map {|item| item.price }.sum{|p| p}
  end

  def paypal_url(notify_uri, return_url)
    options = {
        business: "#{Rails.application.secrets.paypal_business_email}",
        cmd:      "_cart",
        upload:   1,
        return:   return_url,
        invoice:  self.id,
        currency_code: case self.locale
                         when "pl" then "PLN"
                         when "en" then "EUR"
                         else "EUR"
                       end,
        notify_url: "#{Rails.application.secrets.app_host_external}#{notify_uri}"
    }
    order_items.each_with_index do |item, index|
      options.merge!({
          "amount_#{index + 1}": item.price,
          "item_name_#{index + 1}": item.product.name,
          "quantity_#{index + 1}": 1,
       })
    end
    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr/?" + {cmd: "_s-xclick",encrypted: encrypt_for_paypal(options)}.to_query
  end

  private
    def encrypt_for_paypal(options)
      signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM),
                                    OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''),
                                    options.map { |k, v| "#{k}=#{v}" }.join("\n"),
                                    [],
                                    OpenSSL::PKCS7::BINARY)

      OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)],
                              signed.to_der,
                              OpenSSL::Cipher::Cipher::new("DES3"),
                              OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
    end
end
