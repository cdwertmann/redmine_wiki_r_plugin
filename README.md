R plugin for Redmine Wiki
====

This Redmine Wiki R-macro plugin will allow Redmine to render
graphs generated from inline R code in wiki pages.

The plugin depends on R and xvfb and looks for them in
/usr/bin/xvfb-run and /usr/bin/R respectively.

You need to patch Redmine, otherwise you can't have commas in your R scripts:

Edit lib/redmine/wiki_formatting.rb
In def execute_macros:
$
if macro == 'latex'
args = $5
else
args = ($5 || '').split(',').each(&:strip)
end
$

WARNING: Since the R language has functions to create/modify/delete files
and spawn subprocesses, attackers may use this plugin to compromise your
machine. R and xvfb are started as user "nobody".

Please run "chmod 777 -R tmp/redmine_wiki_r_plugin" to allow the nobody user
to create graph files.

Copyright
----

(c) 2011 Christoph Dwertmann <cdwertmann@gmail.com>
Based on wiki_latex_plugin by Nils Israel <info@nils-israel.net>
Based on wiki_graphviz_plugin by tckz<at.tckz@gmail.com>

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