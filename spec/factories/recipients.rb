FactoryBot.define do
  factory :recipient do
    campaign
    sequence(:name) { |n| "Customer #{n}" }
    sequence(:email) { |n| "customer#{n}@example.com" }
    status { :queued }
    
    trait :sent do
      status { :sent }
    end
    
    trait :failed do
      status { :failed }
      error_message { "Simulated delivery failure" }
    end
  end
end

