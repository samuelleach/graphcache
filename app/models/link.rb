class Link < ActiveRecord::Base
  attr_accessible :source_id, :strength, :target_id
end
