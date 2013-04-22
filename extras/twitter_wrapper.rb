module TwitterWrapper
	def say_tweet
		"Tweet tweet!"
	end

	@@ratelimit_interval_min = 15.0  # Source https://dev.twitter.com/docs/rate-limiting/1.1

	# def ratelimit_check
	# 	remaining_hits = Twitter.get('/1/account/rate_limit_status.json')[:body][:remaining_hits]
	# 	puts 'Remaining hits = '+remaining_hits.to_s
	# end

	def twitterapp_ratelimits
		Twitter.get('/1.1/application/rate_limit_status.json')[:body][:resources]
	end

	def ratelimit_ratelimit
		twitterapp_ratelimits[:application][:"/application/rate_limit_status"]
	end

	def user_ratelimit
		twitterapp_ratelimits[:users][:"/users/show/:id"]
	end

	def ids_ratelimit(type)
		# type should be "friends" or "followers"
		ratelimit = twitterapp_ratelimits[type.to_sym][:"/#{type}/ids"]
		ratelimit.update users_per_cursor: 5000 # Source: https://dev.twitter.com/docs/api/1.1/get/followers/ids
	end

	def list_ratelimit(type)
		# type should be "friends" or "followers"
		ratelimit = twitterapp_ratelimits[type.to_sym][:"/#{type}/list"]
		ratelimit.update users_per_cursor: 20
	end

	def countdown_minutes(ratelimit)
		duration = (ratelimit[:reset]-Time.now.to_i)/60.0
		duration.round(1)
	end

	def twitter_users(user_id, type, cursor)
		# type should be "friends" or "followers"
		options = {:cursor=>cursor}
		case type
		when "friends"
			Twitter.friends(user_id, options)
		when "followers"
			Twitter.followers(user_id, options)
		end
	end

	def twitter_num_users(twitter_user, type)
		# twitter_user is an instance of Twitter.user
		# type should be "friends" or "followers"
		case type
		when "friends"
			twitter_user.friends_count.to_i
		when "followers"
			twitter_user.followers_count.to_i
		end
	end

	def twitter_ids(user_id, type, cursor)
		# type should be "friends" or "followers"
		options = {:cursor=>cursor}
		case type
		when "friends"
			Twitter.friend_ids(user_id, options)
		when "followers"
			Twitter.follower_ids(user_id, options)
		end
	end



end