class CreateListingEmbeddings < ActiveRecord::Migration[8.0]
  def change
    create_table :listing_embeddings do |t|
      t.references :listing, null: false, foreign_key: true, index: { unique: true }
      t.jsonb :embedding, null: false, default: []
      t.text :content, null: false

      t.timestamps
    end
  end
end
