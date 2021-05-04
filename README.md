# Matthew's Shopify Image Repo!

Follow these steps to get setup with this project.
1. Download MySQL
1. Install ruby 3.0.0
1. Run `bundle install` from the root directory of the project.
1. Run `rails db:create`
1. Run `rails db:schema:load`
1. Run `rails db:migrate`
1. Install ImageMagick. Assuming you are using a Mac, you can use: `brew install imagemagick`
1. Run the server with `rails s`. You can then see it at http://localhost:3000
1. Run the tests by first preparing the test db `rails db:test:prepare` then running `rspec spec` from the root directory of the project.

# How it Works

Run the project using the above instructions and visit http://localhost:3000 in your browser. As you can see, the top bar has two links, `Home` and `Upload`.

To add new images to your repo, visit http://localhost:3000/image_rows/new (the Upload URL) and select an image to upload. This project uses Rails' ActiveStorage to handle uploading files. On upload, you will be redirected to the url of your newly uploaded image so that it can be fully viewed. As part of this upload process, the image is stored in another table called `image_search_index`. This table indexes all uploaded images for fast searching later on.

Once you have uploaded some images, head back to the root path http://localhost:3000. Here, you can see a list of all your uploaded images and a search widget. The searching takes advantage of the fact that images are indexed on upload and removed on deletion. This makes search pretty darn fast because now all the searchable data is indexed in the MySQL DB.

You can search with a string (only matches the filename and content type like `image/png`), height and width (using any of <, >, or =), the max file size in bytes, and the upload date as a range.

One more little feature is the bulk action functionality. You can select any number of images (or even all of them in one click!) and then select the `delete` in the select widget to delete all selected images. A select widget is used so that we can easily extend this in the future to account for other bulk actions.

Images are never actually deleted. An is_deleted flag is just set, to enable data recovery later on. It would be a good idea to run a cron or Sidekiq job to periodically cleanup images marked for deletion in a production environment.
