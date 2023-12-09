# frozen_string_literal: true

class InMemoryDataStore
  def self.set(key, value)
    REDIS.set(key, value)
  end

  def self.get(key)
    REDIS.get(key)
  end

  def self.increment(key)
    REDIS.incr(key)
  end

  def self.exists?(key)
    REDIS.exists?(key)
  end
end
