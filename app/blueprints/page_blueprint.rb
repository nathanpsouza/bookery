require 'redcarpet/render_strip'

class PageBlueprint < Blueprinter::Base
  identifier :id

  field :page_number

  field :content do |page, options|
    if render_format = options[:format]
      renderer = Redcarpet::Render::StripDown
      renderer = Redcarpet::Render::HTML if render_format == 'html'
      
      markdown = Redcarpet::Markdown.new(renderer, extensions = {})
      markdown.render(page.content)
    else
      page.content
    end
  end
end