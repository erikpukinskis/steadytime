class CreateGoogleAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :google_accounts, id: false do |t|
      # Google account ID ("sub" in Google's OAuth2 payload)
      t.string :id, primary_key: true, null: false

      # An ID from the user model
      t.references :user, null: false, foreign_key: true

      # Email
      t.string :email, null: false

      # Biographic information
      t.string :name
      t.string :given_name
      t.string :picture_url

      # Auto-generated fields
      t.timestamps
    end

    add_index :google_accounts, :id, unique: true
    add_index :google_accounts, :email, unique: true
  end
end
