require 'elasticsearch'
require 'jbuilder'
require 'hashie'

class SwarmizeSearch
  def self.client
    Elasticsearch::Client.new log: true, host: 'ec2-54-83-167-14.compute-1.amazonaws.com:9200'
  end

  def self.all(page=1, per_page=10)
    query = Jbuilder.encode do |json|
      json.size per_page
      json.from per_page * (page-1)
      json.query do
        json.filtered do
          json.filter do
            json.terms do
              json.feedback %w{lab con ld}
            end
          end
        end
      end
      json.sort do
        json.timestamp "asc"
      end
    end

    search_results = client.search(index: 'voting', body: query)

    search_results_hash = Hashie::Mash.new(search_results)

    total_hits = search_results_hash.hits.total
    per_page = per_page
    total_pages = (total_hits/per_page) + 1

    rows = search_results_hash.hits.hits.map {|h| h._source}
    [rows, total_pages]
  end

end
