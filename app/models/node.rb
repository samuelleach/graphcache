class Node < ActiveRecord::Base
  attr_accessible :created_at, :description, :followers_count, :friends_count, :group_id, :id, :location, :name, :profile_image_url_https, :protected, :statuses_count
end
