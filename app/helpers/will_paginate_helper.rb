module WillPaginateHelper
  class WillPaginateAjaxLinkRenderer < WillPaginate::ActionView::LinkRenderer
    def prepare(collection, options, template)
      options[:params] ||= {}
      options[:params]["_"] = nil
      super(collection, options, template)
    end
    protected
    def page_number(page)
      unless page == current_page
        link(page, page, :rel => rel_value(page))
      else
        link(page, "#", :class => 'active')
      end
    end
    def gap
      text = @template.will_paginate_translate(:page_gap) { '&help;' }
      %(<li class="disabled"><a>#{text}</a></li>)
    end
    def next_page
      num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
      previous_or_next_page(num, @options[:next_label], 'next')
    end
    def previous_or_next_page(page, text, classname)
      if page
        link(text, page, :class => classname)
      else
        link(text, "#", :class => classname + ' disabled')
      end
    end
    def html_container(html)
      tag(:div, tag(:ul, html), container_attributes)
    end
    def link(text, target, attributes = {})
      if target.is_a? Fixnum
        attributes[:rel] = rel_value(target)
        target = url(target)
      end
      ajax_call = "$.ajax({url: '#{target}', dataType: 'script'});"
      
      classname = attributes[:class]
      attributes.delete(:classname)
      tag(:li, @template.link_to_function(text.to_s.html_safe, ajax_call, attributes), :class => classname)
    end
  end

  def ajax_will_paginate(collection, options = {})
    will_paginate(collection, options.merge(:renderer => WillPaginateHelper::WillPaginateAjaxLinkRenderer))
  end
end






