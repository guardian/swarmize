class SwarmizeSearch
  module Queries 
    private

    def all_query(page, per_page)
      Jbuilder.encode do |json|
        json.size per_page
        json.from per_page * (page-1)
        json.sort do
          json.timestamp "desc"
        end
      end
    end

    def aggregate_count_query(field)
      Jbuilder.encode do |json|
        json.aggs do
          json.field_count do
            json.terms do
              json.field field
            end
          end
        end
        json.sort do
          json.timestamp "asc"
        end
      end
    end

    def cardinal_count_query(field, unique_field)
      Jbuilder.encode do |json|
        json.size 0
        json.aggs do
          json.field_count do
            json.terms do
              json.field field
            end
            json.aggs do
              json.unique_field do
                json.cardinality do
                  json.field unique_field
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
  end
end
