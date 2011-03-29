class CreateWikiRs < ActiveRecord::Migration
  def self.up
    create_table :wiki_rs do |t|
      t.column :image_id, :string, :limit => 64, :null => false
      t.column :source, :text, :null => false
    end    
    add_index :wiki_rs, :image_id, :name => :wiki_rs_image_id
  end

  def self.down
    drop_table :wiki_rs
  end
end
