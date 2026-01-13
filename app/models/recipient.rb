class Recipient < ApplicationRecord
  belongs_to :campaign
  
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validates :status, inclusion: { in: %w[queued sent failed] }
  
  enum :status, {
    queued: 0,
    sent: 1,
    failed: 2
  }
  
  def status_badge_class
    case status
    when 'queued'
      'bg-gray-100 text-gray-800'
    when 'sent'
      'bg-green-100 text-green-800'
    when 'failed'
      'bg-red-100 text-red-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end
end
