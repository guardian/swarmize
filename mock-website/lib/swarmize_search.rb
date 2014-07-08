require 'elasticsearch'
require 'jbuilder'
require 'hashie'

class SwarmizeSearch
  def self.client
    Elasticsearch::Client.new log: true, host: 'ec2-54-83-167-14.compute-1.amazonaws.com:9200'
  end

  def self.feedback_filter
    {:filtered =>
      {:filter => 
        {:terms => 
          {:feedback => %w{lab con ld}}
        }
      }
    }
  end

  def self.all_query(page=1, per_page=10)
    Jbuilder.encode do |json|
      json.size per_page
      json.from per_page * (page-1)
      json.query do
        
      end.merge! feedback_filter
      json.sort do
        json.timestamp "asc"
      end
    end
  end

  def self.aggregate_feedback_query
    Jbuilder.encode do |json|
      json.query do
        
      end.merge! feedback_filter
      json.aggs do
        json.feedback_count do
          json.terms do
            json.field "feedback"
          end
        end
      end
      json.sort do
        json.timestamp "asc"
      end
    end
  end

  def self.aggregate_intent_query
    Jbuilder.encode do |json|
      json.size 0
      json.query do
        
      end.merge! feedback_filter
      json.aggs do
        json.feedback_count do
          json.terms do
            json.field "intent"
          end
          json.aggs do
            json.by_user do
              json.cardinality do
                json.field "user_key"
              end
            end
          end
        end
      end
      json.sort do
        json.timestamp "asc"
      end
    end
  end

  def self.all(page=1, per_page=10)
    query = all_query(page, per_page)
    
    search_results = client.search(index: 'voting', body: query)

    search_results_hash = Hashie::Mash.new(search_results)

    total_hits = search_results_hash.hits.total
    per_page = per_page
    total_pages = (total_hits/per_page) + 1

    rows = search_results_hash.hits.hits.map {|h| h._source}
    [rows, total_pages]
  end

  def self.aggregate_feedback
    query = aggregate_feedback_query
    
    search_results = client.search(index: 'voting', body: query)

    search_results_hash = Hashie::Mash.new(search_results)

    buckets = search_results_hash.aggregations.feedback_count.buckets
    buckets.map {|b| {b['key'] => b.doc_count} }
  end

  def self.aggregate_intent
    query = aggregate_intent_query
    
    search_results = client.search(index: 'voting', body: query)

    search_results_hash = Hashie::Mash.new(search_results)

    buckets = search_results_hash.aggregations.feedback_count.buckets
    buckets.map {|b| {b['key'] => b.by_user.value} }

  end

end
