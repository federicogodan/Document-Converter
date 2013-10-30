class ConvertedDocument < ActiveRecord::Base
  STATUSES = {:converting => 0, :failed => 1, :ready => 2}

  validates :status, inclusion: {in: STATUSES.values}

  attr_accessible :size, :download_link, :status,
                  :format_id, :document_id

  #method to set the status to converting
  def set_to_converting
  	self.status = STATUSES[:converting]
  end

  #method to set the status to converting
  def set_to_failed
  	self.status = STATUSES[:failed]
  end

  #method to set the status to converting
  def set_to_ready
  	self.status = STATUSES[:ready]
  end

  belongs_to :document
  belongs_to :format
end
