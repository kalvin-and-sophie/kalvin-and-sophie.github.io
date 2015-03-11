#encoding:utf-8
require 'selenium-webdriver'
require 'rspec'
require 'yaml'

require File.dirname(__FILE__)+'/../tool/login_dialog'
require File.dirname(__FILE__)+'/../action/login_page'

describe "TCM登陆页面测试" do
  include Login_Dialog
  
  before (:all) do
    @data = YAML.load(File.open(File.dirname(__FILE__)+'/../config/login_data.yml'))
  end
  
  before(:each) do
    @dr = Selenium::WebDriver.for(:remote,:url => @data["data"]["mainpage"]["huburl"],:desired_capabilities => :firefox)
    @dr.navigate.to @data["data"]["mainpage"]["url"]
    @dr.manage.window.maximize()
    @driver = Login_Page.new(@dr)
  end
  
  after (:each) do
    @dr.quit
  end
  
  
  context "输入错误的用户名和密码" do
    it "应该出现提示信息'错误的用户和密码'" do
      @driver.login(@data["data"]["logindata"]["wrong"]["username"], @data["data"]["logindata"]["wrong"]["password"])
      expect(@driver.result_message).to eql (@data["data"]["logindata"]["wrong"]["message"])
    end
  end
end


# driver = Selenium::WebDriver.for(:remote,:url => 'http://192.168.199.163:4444/wd/hub',:desired_capabilities => :firefox)
# driver.navigate.to "http://www.baidu.com"
# element = driver.find_element(:id, 'kw')
# element.send_keys "田亚伟喜欢马恒锐"
# element.submit
# puts driver.title
# sleep 10
# driver.quit

# require "selenium-webdriver"
#
# driver = Selenium::WebDriver.for :firefox
# driver.navigate.to "http://www.baidu.com"
#
# element = driver.find_element(:id, 'kw')
# element.send_keys "博亚锐德"
# element.submit
#
# puts driver.title
#
# driver.quit