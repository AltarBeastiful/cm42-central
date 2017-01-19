class AddDisallowJoinToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :disallow_join, :boolean, null: false, default: false
  end
end
