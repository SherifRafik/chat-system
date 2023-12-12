# frozen_string_literal: true

Elasticsearch::Model.client = Elasticsearch::Client.new(url: "http://#{ENV.fetch('ELASTIC_SEARCH_HOST', 'localhost')}:9200")
