class ImageRowsController < ApplicationController

    # very simple code to grab all posts so they can be
    # displayed in the Index view (index.html.erb)
    def index
        @img_rows = img_row_search
    end

    # very simple code to grab the proper Post so it can be
    # displayed in the Show view (show.html.erb)
    def show
        @img = ImageRow.find(params[:id])
        if @img.is_deleted
            @img = nil
        end
        # Index img rows in show because only here will the metadata like height/width actually be written.
        # And, this helps us capture any updates very quickly.
        # Would need some caching logic to prevent hammering the db with these in prod though.
        Search::Index.index_one(@img)
    end

    # very simple code to create an empty post and send the user
    # to the New view for it (new.html.erb), which will have a
    # form for creating the post
    def new
        @img_row = ImageRow.new
    end

    # code to create a new post based on the parameters that
    # were submitted with the form (and are now available in the
    # params hash)
    def create
        new_img = img_params[:img_row]
        new_img[:name] = new_img[:image].original_filename
        @img_row = ImageRow.new(new_img)
        if @img_row.save
            redirect_to image_row_path(@img_row)
        else
            flash[:errors] = @img_row.errors.full_messages
            redirect_to new_image_row_path(@img_row)
        end
    end

    # very simple code to find the post we want and send the
    # user to the Edit view for it(edit.html.erb), which has a
    # form for editing the post
    def edit
        raise NotImplementedError
    end

    # code to figure out which post we're trying to update, then
    # actually update the attributes of that post.  Once that's
    # done, redirect us to somewhere like the Show page for that
    # post
    def update
        raise NotImplementedError
    end

    # very simple code to find the post we're referring to and
    # destroy it.  Once that's done, redirect us to somewhere fun.
    def destroy
        raise NotImplementedError
    end

    def bulk_action
        action = bulk_params[:bulk_action]
        images = bulk_params[:images].map(&:to_i)
        message = ImageRow.perform_bulk_action(action, images)
        redirect_to root_path, :flash => { :info => message }
    end

    private

    def img_params
        params.permit(img_row: [:image])
    end

    def bulk_params
        params.require(:bulk_action)
        params.require(:images)
        params.permit(:bulk_action, :images => [])
    end

    def search_params
        params.permit(:query, :height_op, :height, :width_op, :width, :size, :start_date, :end_date)
    end

    def query_builder
        search_query = search_params.to_h
        search_query.each do |k, v|
            if v.blank?
                search_query.delete(k)
            elsif %w[height width size].include?(k)
                search_query[k] = search_query[k].to_i
            elsif %w[start_date end_date].include?(k)
                search_query[k] = search_query[k].to_datetime
            end
        end
        search_query.symbolize_keys
    end

    def img_row_search
        query = Search::Query.new(**query_builder)
        res = query.search
        ids = res.map { |idx| idx.record_id }
        @img_rows = ImageRow.where(is_deleted: false, id: ids).with_attached_image
    end

end
