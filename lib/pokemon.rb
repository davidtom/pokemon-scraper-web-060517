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
    results = db.execute("SELECT id, name, type FROM pokemon WHERE id = ?", [id]).flatten
    Pokemon.new(results[1]).tap do |pokemon|
      pokemon.id = results[0]
      pokemon.type = results[2]
      pokemon.hp = 60
    end
  end
end
