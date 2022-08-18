class CreateEventInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :event_invitations do |t|
      t.integer :status, default: 0
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
    end
  end
end
