require 'twilio-ruby'
require 'mandrill' 
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :items
  has_and_belongs_to_many :tasks

  def notify(text)
  	if self.email_notifications
  		send_email(text)
  	end
  	if self.text_notifications
  		send_sms(text)
  	end
  end

  private
  def send_sms(text)
  	account_sid = 'ACd9c82ecb10bf6bfc3a4572aed443f882'
	auth_token = 'b2038599737574dd64f3efbbb4187679'
	@client = Twilio::REST::Client.new account_sid, auth_token
 
	message = @client.account.messages.create(
		:body => text,
    	:to => self.phone_no,
    	:from => "+16784363595",
    )
  end

  private
  def send_email(text)
  	m = Mandrill::API.new '1bIbtiJDlLgJjqw4YuPegw'
  	body = "Notification from Room Mate!"
	message = {  
	 :subject=> body,  
	 :from_name=> "Room Mate",  
	 :text=> text,  
	 :to=>[  
	   {  
	     :email=> self.email,  
	     :name=> self.first_name  
	   }  
	 ],  
	 :html=>"<html> #{body} </html>",  
	 :from_email=>"roommate@noreply.com"  
	}  
	sending = m.messages.send message  
  end
end
