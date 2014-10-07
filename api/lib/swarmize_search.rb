require 'elasticsearch'
require 'jbuilder'
require 'hashie'
require 'typhoeus'
require 'typhoeus/adapters/faraday'
require './lib/swarmize_search/queries'

class SwarmizeSearch
  include SwarmizeSearch::Queries
  attr_reader :token

  def initialize(token)
    @token = token
    @client = SwarmizeSearch.client
  end

  def self.client
    #log = Rails.env.development?
    log = false
    Elasticsearch::Client.new log: log, 
      host: ENV['ELASTICSEARCH_HOST'],
      region: 'eu-west-1',
      transport_options: {
        request: { timeout: 30 }
      }
  end

  def search(index, query)
    search_results = @client.search(index: index, body: query)
    Hashie::Mash.new(search_results)
  end

  def total_pages_for_results(results, per_page)
    total_hits = results.hits.total
    (total_hits.to_f/per_page).ceil
  end

  def count_all
    query = all_query(1, 10)
    search_results_hash = search(token,query)
    search_results_hash['hits']['total']
  end

  def all(page=1, per_page=10)
    query = all_query(page, per_page)
    
    search_results_hash = search(token,query)

    rows = search_results_hash.hits.hits.map {|h| h._source}

    total_pages = total_pages_for_results(search_results_hash, per_page)

    [rows, total_pages]
  end

  def latest
    query = latest_query
    search_results_hash = search(token,query)
    rows = search_results_hash.hits.hits.map {|h| h._source}
    rows.first
  end

  def entirety
    results = []
    # scan and scroll
    # Open the "view" of the index with the `scan` search_type
    r = @client.search index: @token,
                      search_type: 'scan', 
                      scroll: '1m', 
                      size: 5000

    while r = @client.scroll(scroll_id: r['_scroll_id'], scroll: '1m') and not r['hits']['hits'].empty? do
      results += r['hits']['hits'].map {|h| Hashie::Mash.new(h['_source'])}
    end
    results
  end

  def aggregate_count(field)
    query = aggregate_count_query(field)
    
    search_results_hash = search(token,query)

    buckets = search_results_hash.aggregations.field_count.buckets

    buckets.map {|b| {b['key'] => b.doc_count} }
  end

  def cardinal_count(field, unique_field)
    query = cardinal_count_query(field, unique_field)
    
    search_results_hash = search(token,query)

    buckets = search_results_hash.aggregations.field_count.buckets

    buckets.map {|b| {b['key'] => b.unique_field.value} }
  end

  def count_over_time(field, interval)
    query = count_over_time_query(field, interval)
    p query
    search_results_hash = search(token,query)
    buckets = search_results_hash.aggregations.field_count.buckets
    buckets.map do |b| 
      results_per_minute = b.results_per_minute.buckets.map do |r|
        p r
        { r['key'] => r.doc_count }
      end
      {b['key'] => results_per_minute }
    end
  end


end
