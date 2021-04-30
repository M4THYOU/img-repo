class ImageRowsController < ApplicationController

    # very simple code to grab all posts so they can be
    # displayed in the Index view (index.html.erb)
    def index
        @img_rows = ImageRow.where(is_deleted: false).with_attached_image
    end

    # very simple code to grab the proper Post so it can be
    # displayed in the Show view (show.html.erb)
    def show
        @img = ImageRow.find(params[:id])
        if @img.is_deleted
            @img = nil
        end
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
        action = bulk_params[:bulk_action].to_i
        images = bulk_params[:images].map(&:to_i)
        if action == ImageRow.bulk_actions[:delete]
            update_vals = {is_deleted: true}
            img_rows = ImageRow.where(id: images)
            puts img_rows
            img_rows.update_all(update_vals)
            redirect_to root_path, :flash => { :success => "Images deleted." }
        else
            redirect_to root_path, :flash => { :error => "Action not implemented." }
        end
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

end
