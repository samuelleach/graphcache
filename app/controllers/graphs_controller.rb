class GraphsController < ApplicationController

include TwitterWrapper

def show
	@links = Link.all
	@nodes = Node.all

   	respond_to do |format|
    	format.html # show.html.erb
   	end
end


def d3data
	@links = Link.all
	@nodes = Node.all

	@nodeslookup = {}
	@d3links = []

	# Reform graph links data for d3
	counter = -1
	@links.each do |link|
		tmplink = {}
		if @nodeslookup[link[:source_id]] == nil
			counter += 1
			tmplink[:source] = counter
			@nodeslookup[link[:source_id]] = counter
		else
			tmplink[:source] = @nodeslookup[link[:source_id]]
		end

		if @nodeslookup[link[:target_id]] == nil
			counter += 1
			tmplink[:target] = counter
			@nodeslookup[link[:target_id]] = counter
		else
			tmplink[:target] = @nodeslookup[link[:target_id]]
		end
		@d3links << tmplink
	end

	# Extracting data about the nodes - need to perform checks and validation
	@d3nodes = []
	@nodeslookup.each do |key, value|
		id = key
		begin
			@node = Node.find(id)
			count = @node[:followers_count]
		rescue
			count = 1 # Need to edit this so that we provide info that there is no node info
		end
		@d3nodes <<  {size: count, id: id}#, name: @node[:name] }
	end

   	respond_to do |format|
    	format.json { render json: {"nodes" => @d3nodes, "links" => @d3links }}#, "lookup" => @nodeslookup} }
   	end
end

def friends

	screen_name = params[:screen_name]
	user = Twitter.user(screen_name.to_s)
	# render :json => user

	cursor = -1
	ids = twitter_ids(user.id, "friends", cursor)
	# render :json => ids

	ids.each do |id|
		link = Link.create(:source_id => user.id, :target_id => id)
	end

	redirect_to :root
end

def followers

	screen_name = params[:screen_name]
	user = Twitter.user(screen_name.to_s)

	cursor = -1
	ids = twitter_ids(user.id, "followers", cursor)

	ids.each do |id|
		link = Link.create(:source_id => id, :target_id => user.id)
	end

	redirect_to :root
end



end