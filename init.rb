require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting wiki_r_plugin'

Redmine::Plugin.register :wiki_r_plugin do
  name 'R Wiki Macro Plugin'
  url 'http://github.com/cdwertmann/redmine_wiki_r_plugin' if respond_to?(:url)
  author 'Christoph Dwertmann'
  author_url 'mailto:cdwertmann@gmail.com'
  description 'Render R graphs'
  version '0.1'

	Redmine::WikiFormatting::Macros.register do

		desc <<'EOF'
R Plugin
{{r(place inline R code here)}}

Don't use curly braces. '
EOF
		macro :r do |wiki_content_obj, args|
			m = WikiRHelper::Macro.new(self, args.to_s)
			m.render
		end

    # code borrowed from wiki template macro
    desc <<'EOF'
Include wiki page rendered with R.
{{r_include(WikiName)}}
EOF
    macro :r_include do |obj, args|
      page = Wiki.find_page(args.to_s, :project => @project)
      raise 'Page not found' if page.nil? || !User.current.allowed_to?(:view_wiki_pages, page.wiki.project)

      @included_wiki_pages ||= []
      raise 'Circular inclusion detected' if @included_wiki_pages.include?(page.title)
      @included_wiki_pages << page.title
      m = WikiRHelper::Macro.new(self, page.content.text)
      @included_wiki_pages.pop
      m.render_block(args.to_s)
    end
  end

end
