class CreateRecipients < ActiveRecord::Migration[7.1]
  def change
    create_table :recipients do |t|
      t.references :campaign, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.integer :status, default: 0, null: false
      t.text :error_message

      t.timestamps
    end
    
    add_index :recipients, :status
    add_index :recipients, [:campaign_id, :status]
  end
end

