ActiveAdmin.register Result do
  menu false

  index do
    selectable_column
    column :title do |result|
      link_to result.title, result.title, target: "_blank"
    end
    column :link do |result|
      link_to result.link, result.link, target: "_blank"
    end
    actions
  end
end
