# -*- coding: utf-8 -*-
require 'sinatra'
require 'open-uri'
require 'net/http'

blog_host = "www.acmhacker.com"

get // do
  path = request.path_info
  uri = "http://#{blog_host}/#{path}"

  uri = URI(uri)
  response = Net::HTTP.get_response(uri)

  html = response.body

  # 指定content_type，否则默认指定为text, css部分不会渲染
  # Resource interpreted as stylesheet but transferred with MIME type text/plain
  content_type response.content_type
  
  html = html.gsub(blog_host, '127.0.0.1:4567')
end
