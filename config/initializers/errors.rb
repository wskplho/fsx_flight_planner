ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /^<label/
    html_tag
  else
    if instance.error_message.is_a? Array
      %(<span class="error">#{ html_tag } <span class="message">#{ instance.error_message.join(', ') }</span></span>).html_safe
    else
      %(<span class="error">#{ html_tag } <span class="message">#{ instance.error_message }</span></span>).html_safe
    end
  end
end