class WikiRController < ApplicationController

  def image
    @r = WikiR.find_by_image_id(params[:image_id])
    @name = params[:image_id]
    if @name != "error"
      image_file = File.join([RAILS_ROOT, 'tmp', 'wiki_r_plugin', @name+".png"])
    else
      image_file = File.join([RAILS_ROOT, 'public', 'plugin_assets', 'wiki_r_plugin', 'images', 'error.png'])
    end
    if (!File.exists?(image_file))
      render_image
    end
    if (File.exists?(image_file))
      render :file => image_file, :layout => false, :content_type => 'image/png'
    else
      render_404
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def output
    @r = WikiR.find_by_image_id(params[:image_id])
    @name = params[:image_id]
    if @name != "error"
      out_file = File.join([RAILS_ROOT, 'tmp', 'wiki_r_plugin', @name+".out"])
    else
      out_file = File.join([RAILS_ROOT, 'public', 'plugin_assets', 'wiki_r_plugin', 'images', 'error.png'])
    end
    if (File.exists?(out_file))
      #render :file => out_file, :layout => false, :content_type => 'text/plain'
      render :update do |page|
        page.replace_html @name, :file => out_file, :layout => 'layouts/output.html.erb'
      end
    else
      render_404
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def redraw
    @r = WikiR.find_by_image_id(params[:image_id])
    @name = params[:image_id]

    return if @name.include? "/"

    image_file = File.join([RAILS_ROOT, 'tmp', 'wiki_r_plugin', @name+".png"])
    out_file = File.join([RAILS_ROOT, 'tmp', 'wiki_r_plugin', @name+".out"])

    File.unlink(out_file) if (File.exists?(out_file))
    File.unlink(image_file) if (File.exists?(image_file))
    render :update do |page|
      page.reload
    end
  end


  private
  def render_image
    dir = File.join([RAILS_ROOT, 'tmp', 'wiki_r_plugin'])
    begin
      Dir.mkdir(dir)
    rescue
    end
    basefilename = File.join([dir,@name])
    temp_r = File.open(basefilename+".r",'w')
    #temp_r.puts('system("whoami");')
    #temp_r.puts('system("pwd");')
    #temp_r.puts('library(DBI); library(RSQLite); driver<-dbDriver("SQLite");')
    #temp_r.puts('connect<-dbConnect(driver, dbname = "/tmp/default_slice-2011-01-27t10.55.57+11.00.sq3");')
    temp_r.puts('png("'+@name+'.png"); par(bg="aliceblue"); frame(); title(main="No graph was generated");')  
    temp_r.puts @r.source
    temp_r.puts('dev.off();')
    temp_r.flush
    temp_r.close

    fork_exec(dir, "/usr/bin/xvfb-run -a /usr/bin/R --vanilla < "+@name+".r > "+@name+".out")
    #fork_exec(dir, "sudo -u nobody /usr/bin/xvfb-run -a /usr/bin/R --vanilla < "+@name+".r > "+@name+".out")

    #fork_exec(dir, "/usr/bin/dvipng "+@name+".dvi -o "+@name+".png")
    #['tex','dvi','log','aux','ps'].each do |ext|
    #  if File.exists?(basefilename+"."+ext)
    #    File.unlink(basefilename+"."+ext)
    #  end
    #end
  end

  def fork_exec(dir, cmd)
    pid = fork{
      Dir.chdir(dir)
      exec(cmd)
      exit! ec
    }
    ec = nil
    begin
      Process.waitpid pid
      ec = $?.exitstatus
    rescue
    end
  end

end
