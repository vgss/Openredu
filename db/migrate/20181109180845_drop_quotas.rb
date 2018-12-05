class DropQuotas < ActiveRecord::Migration
    def up
      drop_table :quotas
    end
  
    def down
      t.integer  :multimedia,    :default => 0
      t.integer  :files,         :default => 0
      t.integer  :billable_id
      t.string   :billable_type
      t.timestamps
    end
  end
  