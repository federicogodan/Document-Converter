class ConvertedDocument < ActiveRecord::Base
  STATUSES = {:converting => 0, :failed => 1, :ready => 2}

  validates :status, inclusion: {in: STATUSES.values}

  attr_accessible :size, :download_link#, :status

  belongs_to :document
  belongs_to :format

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

  def current_status
    if status == nil
      STATUSES.keys.first
    else
      STATUSES.keys[status]
    end
  end

end
