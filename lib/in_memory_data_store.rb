# frozen_string_literal: true

class InMemoryDataStore
  def self.hincrby(key, field)
    REDIS.hincrby(key, field)
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
