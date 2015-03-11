#encoding:utf-8

require 'selenium-webdriver'

module Login_Dialog
  
  def ipt_username
    @dr.find_element(:id, 'inputEmail3')
  end
  
  def ipt_password
    @dr.find_element(:id, 'inputPassword3')
  end
  
  def btn_submit
    @dr.find_element(:id, 'login-btn')
  end
  
  def msg_login_result
    @dr.find_element(:id, 'login-alert')
  end
  
end