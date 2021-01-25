class CreateCoinbaseRates < ActiveRecord::Migration[6.0]
  def change
    create_table :coinbase_rates do |t|
      t.references :pair, null: false, foreign_key: { to_table: :coinbase_pairs }
      t.timestamp :time
      t.decimal :low
      t.decimal :high
      t.decimal :open
      t.decimal :close
      t.decimal :volume
      t.integer :interval

      t.timestamps
    end

    add_index :coinbase_rates, %i[time interval]
  end
end
