class Campaign < ApplicationRecord
  has_many :recipients, dependent: :destroy
  
  accepts_nested_attributes_for :recipients, allow_destroy: true, reject_if: :all_blank
  
  validates :title, presence: true
  validates :status, inclusion: { in: %w[pending processing completed] }
  
  enum :status, {
    pending: 0,
    processing: 1,
    completed: 2
  }
  
  after_create_commit -> { broadcast_refresh_to "campaigns" }
  after_update_commit -> { broadcast_refresh_to "campaigns" }
  
  def sent_count
    recipients.where(status: 'sent').count
  end
  
  def failed_count
    recipients.where(status: 'failed').count
  end
  
  def queued_count
    recipients.where(status: 'queued').count
  end
  
  def total_count
    recipients.count
  end
  
  def progress_percentage
    return 0 if total_count.zero?
    ((sent_count + failed_count).to_f / total_count * 100).round
  end
  
  def status_badge_class
    case status
    when 'pending'
      'bg-yellow-100 text-yellow-800'
    when 'processing'
      'bg-blue-100 text-blue-800'
    when 'completed'
      'bg-green-100 text-green-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end
end
