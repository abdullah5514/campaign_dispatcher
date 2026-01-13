class CreateCampaigns < ActiveRecord::Migration[7.1]
  def change
    create_table :campaigns do |t|
      t.string :title, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
    
    add_index :campaigns, :status
  end
end

