#tmsnippets2gedit
#05 May 2009
#Quick and dirty code to transform textmate snippets into gedit snippets xml

require 'rubygems'
require 'nokogiri'

def convert(file)
  xml = File.read(file)
  
  doc = Nokogiri::XML(xml)
  i = 0
  j = 0
  snippet = ""
  arrKey = Array.new
  arrString = Array.new
  #Transform the key and string node into arrays
  doc.xpath('//key','//string').each do |key|
    if key.name == "key"
      arrKey[i] = key.text
      i+=1
    else
      arrString[j] = key.text
      j+=1
    end
  end

puts arrKey.inspect 
puts arrString.inspect 
  if arrKey.index('tabTrigger')
    #Output to Gedit format
    snippet += "  <snippet>\n"
    snippet += "    <tag>#{arrString[arrKey.index('tabTrigger')].gsub('.','')}</tag>\n" #Need to gsub because Gedit doesn't seem to like dot on the tag
    snippet += "    <description>#{arrString[arrKey.index('name')]}</description>\n"
    snippet += "    <text><![CDATA[#{arrString[arrKey.index('content')].gsub('\$','$')}]]></text>\n"
    snippet += "  </snippet>\n"
  else
    return ""
  end
  return snippet
end


def snipetDir( dir ) 

	output = ""
	output += "<?xml version='1.0' encoding='utf-8'?>
	<snippets language=\"[LANGUAGE]\">\n"

	for file in Dir.glob( dir + "Snippets/*.tmSnippet")
	  puts "Converting #{file} ..."
	  output += convert(file)
	end
	output += "</snippets>"

	File.open("result.xml", "w") do |f|
	  f.write(output)
	end
end 

$path = ""
if ( ! ARGV.empty? ) 
	$path = ARGV[0]
end

puts snipetDir( $path )
puts "**** Done, result stored in result.xml, don't forget to change the [language] value ****"

