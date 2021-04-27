module ApplicationHelper

    def active_url(link_path)
        request.fullpath == link_path ? "active" : ""
    end

end
