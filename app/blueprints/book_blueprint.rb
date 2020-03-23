class BookBlueprint < Blueprinter::Base
  identifier :slug

  fields :title, :description
end