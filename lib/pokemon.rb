require "pry"

class Pokemon
  attr_accessor :id, :name, :type, :db, :hp
  attr_writer
  attr_reader

  def initialize(name)
    @name = name
  end

  def self.save(name, type, db)
    values = [name, type]
    ins = db.prepare("INSERT OR IGNORE INTO pokemon (name, type) VALUES(?, ?);")
    ins.execute(values)
  end

  def self.find(id, db)
    #check if there is an hp column or not and run corresponding query
    if db.execute("PRAGMA table_info(pokemon)").flatten.include?("hp")
      results = db.execute("SELECT id, name, type, hp FROM pokemon WHERE id = ?", [id])[0]
    else
      results = db.execute("SELECT id, name, type FROM pokemon WHERE id = ?", [id])[0]
    end
    poke = Pokemon.new(results[1]).tap do |pokemon|
      pokemon.id = results[0]
      pokemon.type = results[2]
      pokemon.hp = results[3]
    end
  end

  def alter_hp(new_hp, db)
    sql = <<-SQL
    UPDATE pokemon SET hp = ? WHERE id = ?;
    SQL
    db.execute(sql, new_hp, self.id)
  end
end
