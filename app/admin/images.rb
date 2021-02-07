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
      link_to 'Search', search_admin_image_path(item), style: "font-weight: bold; "
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

  member_action :search, method: :get do
    image = Image.find(params[:id])
    url = url_for(image.file)
    image_url = CGI.escape(url)

    url = Finder.new(image_url).find_similar
    redirect_to url
  end
end
