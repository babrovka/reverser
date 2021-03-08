ActiveAdmin.register Image do
  permit_params :title, :file

  index do
    selectable_column
    id_column
    column :title
    column :file do |instance|
      image_tag url_for(instance.file), style: "max-width: 300px; height: auto; "
    end
    actions defaults: true do |item|
      link_to 'Search', query_admin_image_path(item), style: "font-weight: bold; "
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :file, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :file do |instance|
        image_tag instance.file
      end
    end
  end

  member_action :query, method: :get do
    @image = Image.find(params[:id])
    url = url_for(@image.file)
    @escaped_url = CGI.escape(url)
  end

  member_action :search, method: :post do
    @response = Finder.new(params).find_similar
    # redirect_to @response
    render inline: @response
  end
end
