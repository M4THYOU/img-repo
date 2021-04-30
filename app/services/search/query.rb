module Search
    class Query
        include Service

        # @param query [String]
        def initialize(query)
            @query = query
        end

        private

        def search
            raise NotImplementedError
        end

    end
end
