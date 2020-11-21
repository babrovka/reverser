ActiveAdmin.register Result do
  index do
    selectable_column
    column :title
    column :link do |result|
      link_to result.link, result.link, target: "_blank"
    end
    actions
  end
end
