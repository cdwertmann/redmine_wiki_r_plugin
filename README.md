R plugin for Redmine Wiki
====

This Redmine Wiki R-macro plugin will allow Redmine to render
graphs generated from inline R code in wiki pages.

Prerequisites
----

The plugin has been tested with Redmine 1.0.2 on Ubuntu 10.10. YMMV on other platforms or distributions.

It depends on R and xvfb and looks for them in */usr/bin/xvfb-run* and */usr/bin/R* respectively.
On a Ubuntu installation, you can use

	sudo apt-get install xvfb r-base

to install them.

You need to patch Redmine, otherwise you can't have commas in your R scripts.

#### Edit lib/redmine/wiki\_formatting.rb, function 'def execute_macros' and replace:

	args = ($5 || '').split(',').each(&:strip)

#### with

	if macro == 'r'
	  args = $5
	else
	  args = ($5 || '').split(',').each(&:strip)
	end

Installation
----

See the [guide](http://www.redmine.org/projects/redmine/wiki/Plugins) on the Redmine site.

Security
----

**WARNING:** Since the R language has functions to create/modify/delete files
and spawn subprocesses, attackers maybe able to use this plugin to compromise your
machine. As a security measure, R and xvfb are started as user *nobody* using sudo.
Use this plugin at your own risk, especially on wikis with public editing that are open to
everyone.

In your RAILS_ROOT (e.g. */usr/share/redmine*), please run:

	mkdir -p tmp/redmine_wiki_r_plugin
	chmod 777 -R tmp/redmine_wiki_r_plugin

to allow any user to write graph files there. If your rails server or apache is running as a user other than *nobody*, e.g. *www-data*, you need to allow that user to execute programs as user *nobody* using sudo. This is done by adding a line to */etc/sudoers* :

	www-data ALL=(nobody) NOPASSWD: /usr/bin/xvfb-run

Usage
----

Edit a Redmine wiki page and insert your R code like this:

	{{R(
	png("%PNG%")
	bars <- c(1, 3, 5)
	pie(bars, main="Pie Chart: Favourite Bars", col=rainbow(length(bars)),labels=c("Mars","Twix","KitKat"))
	)}}

Please do not use curly braces inside the R code. The **%PNG%** marker will be replaced by the plugin with the full path to a PNG image file in Redmine's tmp directory. At the moment, the plugin only supports one image file generated per R script.

After you click on *Preview* or *Save*, you should see a graph in your wiki page. Click *Show R output* if no graph is displayed to see if R has produced an error message. Also check your *production.log* for errors and ensure you've followed all the installation steps mentioned above.

Copyright
----

(c) 2011 Christoph Dwertmann <cdwertmann@gmail.com>

Based on wiki\_latex\_plugin by Nils Israel <info@nils-israel.net>

Based on wiki\_graphviz\_plugin by tckz <at.tckz@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
