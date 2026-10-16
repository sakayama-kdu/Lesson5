class HashLegacyUserPasswords < ActiveRecord::Migration[8.1]
  def up
    require "bcrypt"

    select_all(<<~SQL).each do |user|
      SELECT id, pass FROM users
      WHERE pass IS NOT NULL AND pass != '' AND password_digest IS NULL
    SQL
      digest = BCrypt::Password.create(user["pass"])
      execute <<~SQL
        UPDATE users
        SET password_digest = #{connection.quote(digest)}
        WHERE id = #{user["id"].to_i}
      SQL
    end

    remove_column :users, :pass
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "BCrypt password digests cannot be converted back to plaintext"
  end
end