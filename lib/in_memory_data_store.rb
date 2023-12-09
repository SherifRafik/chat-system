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

  def self.hset(key, field, value)
    REDIS.hset(key, field, value)
  end

  def self.hgetall(key)
    REDIS.hgetall(key)
  end

  def self.hget(key, field)
    REDIS.hget(key, field)
  end
end
