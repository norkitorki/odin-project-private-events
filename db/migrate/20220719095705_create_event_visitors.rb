class CreateEventVisitors < ActiveRecord::Migration[7.0]
  def change
    create_table :event_visitors, id: false do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
    end
  end
end
