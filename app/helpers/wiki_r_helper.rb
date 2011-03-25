require 'digest/sha2'
require	'tempfile'

module WikiRHelper
  def render_image_tag(image_name, source)
    render_to_string :template => 'wiki_r/macro_inline', :layout => false, :locals => {:name => image_name, :source => source}
  end

  def render_image_block(image_name, source, wiki_name)
    render_to_string :template => 'wiki_r/macro_block', :layout => false, :locals => {:name => image_name, :source => source, :wiki_name => wiki_name}
  end
	class Macro
		def initialize(view, source)
		  @view = view
		  @view.controller.extend(WikiRHelper)
			source.gsub!(/<br \/>/,"")
			source.gsub!(/<\/?p>/,"")
			# defuse some malicious commands: system, unlink, file.*
			source.gsub!(/system\s*\(/,"print(")
			source.gsub!(/unlink\s*\(/,"print(")
			source.gsub!(/file.\w*\s*\(/,"print(")
			name = Digest::SHA256.hexdigest(source)
			if !WikiR.find_by_image_id(name)
				@r = WikiR.new(:source => source, :image_id => name)
				@r.save
			end
			@r = WikiR.find_by_image_id(name)
		end

		def render()
		  if @r
		    @view.controller.render_image_tag(@r.image_id, @r.source)
		  else
		    @view.controller.render_image_tag("error", "error")
		  end
		end
		def render_block(wiki_name)
		  if @r
		    @view.controller.render_image_block(@r.image_id, @r.source, wiki_name)
		  else
		    @view.controller.render_image_block("error", "error", wiki_name)
		  end
		end
	end
end
