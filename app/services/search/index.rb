module Search
    # Search::Index handles all indexing for new uploads and deletions.
    module Index
        include Service

        class << self
            # Indexes the given image_row.
            # @param img_row [ImageRow]
            def index_one(img_row)
                val = {
                    record_id: img_row.id,
                    filename: img_row.image.filename.to_s,
                    content_type: img_row.image.content_type,
                    height: img_row.image.metadata[:height],
                    width: img_row.image.metadata[:width],
                    byte_size: img_row.image.byte_size,
                    created_at: img_row.image.created_at
                }
                puts 'aaaaaaa'
                puts img_row.image.metadata
                ImageSearchIndex.create!(val)
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
end
