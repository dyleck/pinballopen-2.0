module ApplicationHelper
  def format_currency(amount, options = {})
    locale = options[:locale].nil? ? I18n.locale.to_s : options[:locale].to_s
    if locale == "pl"
      number_to_currency amount, unit: "zł", format: "%n %u"
    elsif locale == "en"
      number_to_currency amount, unit: "&#8364;".html_safe, format: "%n %u"
    else
      number_to_currency amount
    end
  end
end
