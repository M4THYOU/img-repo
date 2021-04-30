module Search
    class Query
        include Service

        # @param query [String]
        def initialize(query)
            @query = query
        end

        def search
            _search
        end

        private

        def _search
            raise NotImplementedError
        end

    end
end
