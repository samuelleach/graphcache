class Link < ActiveRecord::Base
  attr_accessible :source_id, :strength, :target_id

  validates :source_id, :target_id, :presence => true
end
