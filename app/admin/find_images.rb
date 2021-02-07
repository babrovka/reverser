ActiveAdmin.register_page "Find images" do
  menu false

  content do
    render partial: 'finder_form'
  end

  page_action :find_images, method: :post do
    begin
      Finder.new(params).find_similar
      redirect_to admin_results_path
    rescue => error
      redirect_to admin_find_images_path, flash: { error: error.message }
    end
  end
end
