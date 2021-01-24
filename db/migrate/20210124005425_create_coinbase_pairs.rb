class CreateCoinbasePairs < ActiveRecord::Migration[6.0]
  def change
    create_table :coinbase_pairs do |t|
      t.string :symbols, null: false
      t.references :base_currency, null: false, foreign_key: { to_table: :coinbase_currencies }, index: true
      t.references :quote_currency, null: false, foreign_key: { to_table: :coinbase_currencies }, index: true
      t.string :status, null: false

      t.timestamps
    end
  end
end
