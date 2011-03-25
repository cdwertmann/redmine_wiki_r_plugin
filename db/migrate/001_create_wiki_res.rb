class CreateWikirs < ActiveRecord::Migration
  def self.up
    create_table :wiki_rs do |t|
      t.column :hash, :string, :limit => 64, :null => false
      t.column :source, :text, :null => false
    end    
    add_index :wiki_rs, :hash, :name => :wiki_rs_hash
  end

  def self.down
    drop_table :wiki_rs
  end
end
