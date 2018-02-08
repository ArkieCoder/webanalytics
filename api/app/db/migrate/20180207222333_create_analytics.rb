class CreateAnalytics < ActiveRecord::Migration[5.1]
  def up
    create_table :analytics do |t|
      t.bigint :ts
      t.string :user
      t.string :event
    end
  end

  def down
    drop_table :analytics
  end
end
