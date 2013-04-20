class GraphsController < ApplicationController

def show
	@links = Link.all
	@nodes = Node.all

   	respond_to do |format|
    	format.html # show.html.erb
   	end
end




end