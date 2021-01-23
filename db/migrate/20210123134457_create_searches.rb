class CreateSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :searches do |t|
      t.jsonb :query_params, null: false
      t.string :search_type, null: false
      t.jsonb :result
      t.timestamp :expires_at, null: false
      t.string :cursor
      t.integer :limit

      t.timestamps
    end

    add_index :searches, %i[query_params search_type cursor limit], name: :idx_searches_on_multiple_columns
  end
end
