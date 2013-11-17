class User
	include MongoMapper::Document

	key :user_id, Integer      
	key :login_name, String		
	key :primary_email, String 
	key :creation_tsz, Float
	key :referred_by_user_id, Integer
	key :feedback_info, Array
end