# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning up existing data..."
Campaign.destroy_all

puts "Creating sample campaign..."
campaign = Campaign.create!(
  title: "Demo Campaign - Customer Feedback Request",
  status: :pending
)

# Create some sample recipients
10.times do |i|
  campaign.recipients.create!(
    name: "Customer #{i + 1}",
    email: "customer#{i + 1}@example.com",
    status: :queued
  )
end

puts "Created campaign '#{campaign.title}' with #{campaign.recipients.count} recipients."
puts "You can now dispatch this campaign from the web interface!"

