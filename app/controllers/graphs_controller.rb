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
	@links_raw = Link.all
	@nodes = Node.all

	# Perform and initial filter of the data to remove nodes with only one edge
	@nodes_lookup = {}
	@links_raw.each do |link|
		link_source_id = link[:source_id]
		link_target_id = link[:target_id]
		if @nodes_lookup[link_source_id] == nil
			@nodes_lookup[link_source_id] = 1
		else
			@nodes_lookup[link_source_id] += 1
		end
		if @nodes_lookup[link_target_id] == nil
			@nodes_lookup[link_target_id] = 1
		else
			@nodes_lookup[link_target_id] += 1
		end
	end
	@links = []
	@links_raw.each do |link|
		if @nodes_lookup[link[:source_id]] > 2 && @nodes_lookup[link[:target_id]] > 2
			@links << link
		end
	end

	# Reform graph links data for d3
	@nodeslookup = {}
	@d3links = []
	counter = -1
	@links.each do |link|
		tmplink = {}

		link_id = link[:source_id]
		link_key = :source
		if @nodeslookup[link_id] == nil
			counter += 1
			tmplink[link_key] = counter
			@nodeslookup[link_id] = { node_id: counter, num_links_as_source: 1, num_links_as_target: 0 }
		else
			tmplink[link_key] = @nodeslookup[link_id][:node_id]
			@nodeslookup[link_id][:num_links_as_source] += 1
		end

		link_id = link[:target_id]
		link_key = :target
		if @nodeslookup[link_id] == nil
			counter += 1
			tmplink[link_key] = counter
			@nodeslookup[link_id] = { node_id: counter, num_links_as_target: 1, num_links_as_source: 0 }
		else
			tmplink[link_key] = @nodeslookup[link_id][:node_id]
			@nodeslookup[link_id][:num_links_as_target] += 1
		end
		@d3links << tmplink
	end

	# Extracting data about the nodes
	@d3nodes = []
	@nodeslookup.each do |key, value|
		id = key
		nodeinfo = value
		begin
			@node = Node.find(id)
			count = @node[:followers_count]
			name = @node[:name]
		rescue
			count = nodeinfo[:num_links_as_target]
			name = ''
		end

		@d3nodes <<  {size: count, id: id , name: name,
					 num_links_as_source: nodeinfo[:num_links_as_source],
					 num_links_as_target: nodeinfo[:num_links_as_target] }
	end


	# Apply a weight to each link. link weight = 0 if it is attached to a node
	# with only one edge, else the weight = 1.
	i = -1
	@d3links.each do |link|
		i += 1
		source_node = @d3nodes[link[:source]]
		target_node = @d3nodes[link[:target]]

		if source_node[:num_links_as_source] + source_node[:num_links_as_target] == 1 ||
			target_node[:num_links_as_source] + target_node[:num_links_as_target] == 1
			link[:weight] = 0
		else
			link[:weight] = 1
		end
	end



   	respond_to do |format|
    	format.json { render json: {"nodes" => @d3nodes, "links" => @d3links } }#, "test" => @nodeslookup_new } }
   	end
end

def friends

	screen_name = params[:screen_name]
	user = Twitter.user(screen_name)
	# render :json => user

	cursor = -1
	ids = twitter_ids(user.id, "friends", cursor)
	# render :json => ids

	if ids.attrs[:next_cursor] == 0
		node = Node.find_by_id(user.id) || Node.create(:id => user.id)
		node = Node.update(user.id, :friends_count => ids.attrs[:ids].length)
		node = Node.update(user.id, :name => user.name)
	end

	ids.each do |id|
		link = Link.create(:source_id => user.id, :target_id => id)
	end

	redirect_to :root
end

def followers

	screen_name = params[:screen_name]
	user = Twitter.user(screen_name)

	cursor = -1
	ids = twitter_ids(user.id, "followers", cursor)
	# pry.instance

	if ids.attrs[:next_cursor] == 0
		node = Node.find_by_id(user.id) || Node.create(:id => user.id)
		node = Node.update(user.id, :followers_count => ids.attrs[:ids].length)
		node = Node.update(user.id, :name => user.name)
	end

	ids.each do |id|
		link = Link.create(:source_id => id, :target_id => user.id)
	end

	redirect_to :root
end



end