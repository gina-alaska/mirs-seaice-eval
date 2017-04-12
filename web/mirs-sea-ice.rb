#!/usr/bin/env ruby
require "date"

###
# Very simple and rough listing web widget.  Just for sea ice eval. 

list = Dir.glob("/www/hippy/htdocs/distro/processing/amsu/geotif/*/*sea_ice*.tif") 
list += Dir.glob("/www/hippy/htdocs/distro/processing/atms/geotif/*/*sea_ice*.tif")

def get_date_of_pass(item)
  DateTime.strptime(File.basename(item).split('_')[-4, 2].join('_'), '%Y%m%d_%H%M%S')
end

def nice_date(item)
	get_date_of_pass(item).strftime("%D %T %z")
end

def get_url(item)
	"http://hippy.gina.alaska.edu/distro" + item.split("distro")[1]
end

def get_overview_url(item)
	get_url(File.dirname(item) + "/" + File.basename(item, ".tif") + ".png")
end

def get_platform( item ) 
	File.basename(item).split("_")[2]
end

def generate_header()
        html = ""
        html += "<tr>"
        html += "<th> Platform </th>"
        html += "<th> Date </th>"
        html += "<th> Overview </th>"
        html += "</tr>"
end


def generate_row(item)
	html = ""
	html += "<tr>"
	html += "<td> #{get_platform( item )} </td>"
	html += "<td> #{nice_date(item)} </td>"
	html += "<td> <A HREF=\"#{get_url(item)}\" > <IMG SRC=#{get_overview_url(item)} WIDTH=256 > </a> </td>"
	html += "</tr>"
end


def list_of_tifs_to_table(list)

	list.sort! { |x,y| get_date_of_pass(x) <=> get_date_of_pass(y) }
	html = ""
	html += generate_header
	list.each do |item|
		#html += "<tr> <td> #{item} </td> </tr>"
		html += generate_row(item)
	end

	html
end

require "cgi"
cgi = CGI.new("html4")
cgi.out do 
   cgi.html do 
      cgi.head{ "\n"+cgi.title{"MIRS Sea Ice Products"}  } +
      cgi.h1{ "This page lists the MIRS Sea Ice Products for the sea ice evaluation for the NWS's sea ice desk."} + 
      cgi.body do  "\n" + 
	cgi.table  { list_of_tifs_to_table(list) } + "\n"
      end
   end
end
