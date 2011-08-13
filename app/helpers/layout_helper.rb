# encoding: utf-8

module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def add_link(options)
    render :partial => 'shared/add_link', :locals => { :name => options[:name], :url => options[:url], :id => options[:id] }
  end

  def edit_link(options)
    render :partial => 'shared/edit_link', :locals => { :name => options[:name], :url => options[:url] }
  end

  def delete_link(options)
    render :partial => 'shared/delete_link', :locals => { :name => options[:name], :url => options[:url] }
  end

  def show_link(options)
    render :partial => 'shared/show_link', :locals => { :name => options[:name], :url => options[:url] }
  end

  def back_link(text, url)
    links = []
    links << link_to(t('my.back'), :back)
    links << link_to(text, url)
    raw links.join ' | '
  end
end