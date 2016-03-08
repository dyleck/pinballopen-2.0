module ApplicationHelper
  def format_currency(amount)
    if I18n.locale == :pl
      number_to_currency amount, unit: "zł", format: "%n %u"
    elsif I18n.locale = :en
      number_to_currency amount, unit: "&#8364;".html_safe, format: "%n %u"
    else
      number_to_currency amount
    end
  end
end
