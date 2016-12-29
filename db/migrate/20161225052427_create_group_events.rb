class CreateGroupEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :group_events do |t|
      t.integer :duration
      t.datetime :start_time
      t.string :end_time
      t.string :name
      t.text :description
      t.string :location
      t.boolean :draft, :default => true
      t.boolean :removed, :default => false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
