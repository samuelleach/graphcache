class SessionsController < ApplicationController
	def create
	  	user = User.from_omniauth(env["omniauth.auth"])
	  	session[:user_id] = user.id
	  	
# Request parameters (params)	
# {"oauth_token"=>"", "oauth_verifier"=>"", "controller"=>"sessions", "action"=>"create", "provider"=>"twitter"}

		# Twitter.configure do |config|
		# 	config.oauth_token = params['oauth_token']
	 # 		config.oauth_token_secret = params['oauth_verifier']
		# end		

	  	redirect_to root_url, notice: "Signed in!"
	end

	def destroy
	  	session[:user_id] = nil
	  	redirect_to root_url, notice: "Signed out!"
	end
end