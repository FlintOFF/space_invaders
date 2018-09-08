class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true
      t.references :radar, foreign_key: true
      t.text :frame, array: true, default: []
      t.column :status, :integer, default: 0
      t.jsonb :results, default: {}
      t.jsonb :messages, default: {}
      t.timestamps
    end
  end
end
