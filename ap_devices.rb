
require 'watir'
require 'nokogiri'

def search ip, username, password
  url = "http://#{ip}/"
  browser = Watir::Browser.new(:chrome)
  # browser = Watir::Browser.new(:phantomjs)
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
  rates = []
  doc = Nokogiri::HTML.parse(browser.html)
  doc.css('input').select do |item|
    # puts item
    item.attribute('type').to_s == 'radio'
  end.each do |item|
    childrens = item.parent.parent.element_children
    
    mac = childrens[1].content
    rate = childrens[5].content

    puts "#{mac}\t#{rate}"

    mac_address << mac
    rates << rate
    
    # puts item.parent.next_element
    # ids << item.attribute('value').to_s
    # mac_address << item.attribute('value').to_s.gsub('-', ':')
  end

  browser.close  
  return mac_address, rates
end

def main
  # ip = ARGV.first
  username = ARGV[0]
  password = ARGV[1]
  # puts ip
  # raise "ip not set" if ip.nil? or ip == ""
  raise "username not set" if username.nil? or username == ""
  raise "password not set" if password.nil? or password == ""

  ips = ["192.168.80.71", "192.168.80.72", "192.168.80.73", "192.168.80.74", "192.168.80.75"]
  ips.each do |ip|
    puts ip
    search(ip, username, password)    
  end
  
end

if __FILE__ == $0
  main
end
