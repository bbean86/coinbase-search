class CreateCoinbaseCurrencies < ActiveRecord::Migration[6.0]
  def change
    create_table :coinbase_currencies do |t|
      t.string :name, null: false
      t.string :symbol, null: false

      t.timestamps
    end

    add_index :coinbase_currencies, :name
  end
end
