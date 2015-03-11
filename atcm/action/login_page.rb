#encoding:utf-8

require 'selenium-webdriver'
require File.dirname(__FILE__)+'/../tool/login_dialog'

class Login_Page
  include Login_Dialog
  
  def initialize(dr)
    @dr ||= dr
  end
  
  def login(username, password)
    ipt_username.send_keys(username)
    ipt_password.send_keys(password)
    btn_submit.click
  end
  
  def result_message
    msg_login_result.text
  end
end