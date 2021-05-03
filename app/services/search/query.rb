module Search
    # Query is a class rather than a module so that we may more easily extend querying functionality to support things
    #   like access control.
    class Query
        # so the values can be modified & read after initialization
        attr_accessor :query, :height_op, :width_op, :height, :width, :size, :from, :to

        # @param query [String] for filename and content_type
        # @param height_op [String] '<', '>', or '='. Both inequalities are passed to sql as un-strict (eg. >=)
        # @param width_op [String] '<', '>', or '='. Both inequalities are passed to sql as un-strict (eg. >=)
        # @param height [Integer] height in pixels
        # @param width [Integer] width in pixels
        # @param size [Integer] max size of the image in bytes
        # @param start_date [DateTime] timestamp
        # @param end_date [DateTime] timestamp
        def initialize(query: nil, height_op: '<', width_op: '<', height: 720, width: 1280, size: 4294967296, start_date: DateTime.new(1000), end_date: DateTime.now)
            @query = query
            @height_op = height_op
            @width_op = width_op
            @height = height
            @width = width
            @size = size
            @from = start_date
            @to = end_date
        end

        def search
            sql_query = "byte_size <= :size AND created_at >= :from AND created_at <= :to"
            if @height_op == '<'
                sql_query << ' AND height <= :height'
            elsif @height_op == '>'
                sql_query << ' AND height >= :height'
            else # @height_op == '='
                sql_query << ' AND height = :height'
            end
            if @width_op == '<'
                sql_query << ' AND width <= :width'
            elsif @width_op == '>'
                sql_query << ' AND width >= :width'
            else # @@width_op == '='
                sql_query << ' AND width = :width'
            end
            vals = {query: @query, height_op: @height_op, width_op: @width_op, height: @height, width: @width, size: @size, from: @from, to: @to}
            unless @query.nil?
                sql_query << ' AND (filename = :query OR content_type = :query)'
            end
            ImageSearchIndex.where(sql_query, vals)
        end

        private

    end
end
