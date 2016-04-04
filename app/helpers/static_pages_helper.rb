module StaticPagesHelper
  def payment_or_register
    if !current_user.nil? && current_user.activated?
      link_to new_order_path, class: "btn btn-lg btn-primary" do
        t("layouts.header.menu.user.order")
      end
    else
      content =
          link_to signup_path, class: "btn btn-lg btn-primary" do
            t("static_pages.home.slide1.register")
          end
      content += content_tag :p, t("static_pages.home.need_to_register"), class: "need-register"
    end
end
end
