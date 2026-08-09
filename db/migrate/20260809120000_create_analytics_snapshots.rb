class CreateAnalyticsSnapshots < ActiveRecord::Migration[8.0]
  def change
    create_table :analytics_snapshot_records do |t|
      t.string :projection_key, null: false
      t.jsonb :state, null: false, default: {}
      t.bigint :kafka_offset
      t.timestamps
    end

    add_index :analytics_snapshot_records, :projection_key, unique: true
  end
end
