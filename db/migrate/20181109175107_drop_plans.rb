class DropPlans < ActiveRecord::Migration
    def up
      drop_table :plans
    end
  
    def down
      create_table :plans do |t|
        t.string   :state
        t.string   :name
        t.integer  :video_storage_limit
        t.integer  :members_limit
        t.integer  :file_storage_limit
        t.integer  :user_id
        t.integer  :billable_id
        t.string   :billable_type
        t.text     :billable_audit
        t.string   :type
        t.boolean  :current,             :default => false
  
        t.timestamp
      end
    end
  end
  