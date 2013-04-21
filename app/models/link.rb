class Link < ActiveRecord::Base
  attr_accessible :source_id, :strength, :target_id

  validates :source_id, :target_id, :presence => true
#  validates_uniqueness_of :source_id, :scope => :target_id # Violation of this validation gives a slightly confusing error message
  validates :source_id, :uniqueness => { :scope => :target_id }

end