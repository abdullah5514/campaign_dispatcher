FactoryBot.define do
  factory :campaign do
    sequence(:title) { |n| "Customer Feedback Campaign #{n}" }
    status { :pending }
    
    trait :with_recipients do
      after(:create) do |campaign|
        create_list(:recipient, 5, campaign: campaign)
      end
    end
    
    trait :processing do
      status { :processing }
    end
    
    trait :completed do
      status { :completed }
    end
  end
end

