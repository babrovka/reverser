class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|
      t.string :title
      t.string :link

      t.timestamps
    end
  end
end
