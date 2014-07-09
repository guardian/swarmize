require 'elasticsearch'
require 'jbuilder'
require 'hashie'
require './swarmize_search_query'

class SwarmizeSearch
  include SwarmizeSearchQuery
  attr_reader :key

  def initialize(key)
    @key = key
    @client ||= SwarmizeSearch.client
  end

  def self.client
    Elasticsearch::Client.new log: true, host: 'ec2-54-83-167-14.compute-1.amazonaws.com:9200'
  end

  def all(page=1, per_page=10)
    query = all_query(page, per_page)
    
    search_results = @client.search(index: key, body: query)

    search_results_hash = Hashie::Mash.new(search_results)

    total_hits = search_results_hash.hits.total
    per_page = per_page
    total_pages = (total_hits/per_page) + 1

    rows = search_results_hash.hits.hits.map {|h| h._source}
    [rows, total_pages]
  end

  def aggregate_count(field)
    query = aggregate_count_query(field)
    
    search_results = @client.search(index: key, body: query)

    search_results_hash = Hashie::Mash.new(search_results)

    buckets = search_results_hash.aggregations.count.buckets
    buckets.map {|b| {b['key'] => b.doc_count} }
  end

  def cardinal_count(field, unique_field)
    query = cardinal_count_query(field, unique_field)
    
    search_results = @client.search(index: 'voting', body: query)

    search_results_hash = Hashie::Mash.new(search_results)

    buckets = search_results_hash.aggregations.count.buckets
    buckets.map {|b| {b['key'] => b.unique_field.value} }
  end

end
