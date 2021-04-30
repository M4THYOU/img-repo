module Search
    # Search::Index handles all indexing for new uploads and deletions.
    module Index
        include Service

        # Indexes the given image_row.
        def index_one
            raise NotImplementedError
        end

        # Removes index for the given image_row, usually on deletion.
        def un_index_one
            raise NotImplementedError
        end

        # Calls remove_hanging_indices then index_all to keep the search index up to date.
        # In a prod environment, we would never manually call this method. Instead, use a job scheduler like Sidekiq
        #   to periodically (say every 24 hrs, for arguments sake) to automatically clean out the index.
        def clean_index
            remove_hanging_indices
            index_all
        end

        private

        # Checks all the image_rows and creates an index entry for each unindexed one.
        def index_all
            raise NotImplementedError
        end

        # Checks all image_rows against the current search index. Remove indices for deleted image rows.
        def remove_hanging_indices
            raise NotImplementedError
        end

    end
end
