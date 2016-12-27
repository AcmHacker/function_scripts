
require 'watir'
require 'nokogiri'

def search ip, username, password
  url = "http://#{ip}/"
  browser = Watir::Browser.new(:chrome)
  browser.goto(url)

  browser.alert.ok if browser.alert.exists?
  
  browser.frame(:name => 'master').text_field(:id, 'username').set(username)
  browser.frame(:name => 'master').text_field(:id, 'password').set(password)
  browser.frame(:name => 'master').button(:title => 'Login').click
  begin
    url = url + 'index.php?page=master&menu1=Monitoring&menu2=Wireless%20Stations&menu3=Wireless%20Stations&menu4='
    browser.goto(url)
  rescue => err
    browser.alert.ok
    browser.goto(url)
  end

  mac_address = []
  doc = Nokogiri::HTML.parse(browser.html)
  doc.css('input').select do |item|
    item.attribute('type').to_s == 'radio'
  end.each do |item|
    mac_address << item.attribute('value').to_s.gsub('-', ':')
  end
  browser.close
  return mac_address
end

def main
  ip = ARGV.first
  username = ARGV[1]
  password = ARGV[2]
  # puts ip
  raise "ip not set" if ip.nil? or ip == ""
  raise "username not set" if username.nil? or username == ""
  raise "password not set" if password.nil? or password == ""
  puts search(ip, username, password)
end

if __FILE__ == $0
  main
end
