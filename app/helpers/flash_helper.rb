module FlashHelper
  def flash_class(type)
    case type.to_sym
    when :notice, :success
      "bg-green-50 text-green-800"
    when :error, :alert
      "bg-red-50 text-red-800"
    when :warning
      "bg-yellow-50 text-yellow-800"
    else
      "bg-blue-50 text-blue-800"
    end
  end

  def flash_icon(type)
    case type.to_sym
    when :notice, :success
      render_icon("M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z", "text-green-400")
    when :error, :alert
      render_icon("M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z", "text-red-400")
    when :warning
      render_icon("M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z", "text-yellow-400")
    else
      render_icon("M10 18a8 8 0 100-16 8 8 0 000 16zm1-11a1 1 0 10-2 0v2H7a1 1 0 100 2h2v2a1 1 0 102 0v-2h2a1 1 0 100-2h-2V7z", "text-blue-400")
    end
  end

  private

  def render_icon(path, color_class)
    content_tag :div, class: "flex-shrink-0" do
      content_tag :svg, class: "h-5 w-5 #{color_class}", viewBox: "0 0 20 20", fill: "currentColor" do
        content_tag :path, nil, d: path
      end
    end
  end
end 