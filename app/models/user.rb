require 'mandrill' 
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :items
  has_and_belongs_to_many :tasks

  def notify_new_user(email)
    email_new_user(email)
  end

  def notify(task)
  	if self.email_notifications
  		send_email(task)
  	end
  	if self.text_notifications
  #		send_sms(task)
  	end
  end

  private
  def send_sms(task)
  	account_sid = 'ACd9c82ecb10bf6bfc3a4572aed443f882'
	auth_token = '{{ b2038599737574dd64f3efbbb4187679 }}'
	@client = Twilio::REST::Client.new account_sid, auth_token
 
	message = @client.account.messages.create(
		:body => "It is your turn for" + task.name,
    	:to => self.phone_no,
    	:from => "+16784363595",
    )
  end

  private
  def send_email(task)
  	m = Mandrill::API.new '1bIbtiJDlLgJjqw4YuPegw'
  	body = "It\'s your turn Room Mate!"
	message = {  
	 :subject=> body,  
	 :from_name=> "Room Mate",  
	 :text=>"It is your turn for " + task.name,  
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

  private
  def email_new_user(email)
  	m = Mandrill::API.new '1bIbtiJDlLgJjqw4YuPegw'
  	body = "Your roommate invited you to join Room Mate"
	message = {  
	 :subject=> body,  
	 :from_name=> "Room Mate",  
	 :text=>body + " too bad we're exclusive. :(",  
	 :to=>[  
	   {  
	     :email=> email,  
	     :name=> "Friend"  
	   }  
	 ],  
	 :html=>"<html> #{body} </html>",  
	 :from_email=>"roommate@noreply.com"  
	}  
	sending = m.messages.send message  
	puts sending
  end
end
