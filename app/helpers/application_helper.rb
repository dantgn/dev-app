# frozen_string_literal: true

module ApplicationHelper
  def top_menu_link(path, options = {})
    icon_name = options[:icon]
    link_name = options[:name].capitalize
    method = options[:method] || :get
    link_to path, method: method do
      content_tag :span, fa_icon(icon_name, text: link_name)
    end
  end
end
