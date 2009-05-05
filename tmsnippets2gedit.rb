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

  #Output to Gedit format
  snippet += "  <snippet>\r\n"
  snippet += "    <tag>#{arrString[arrKey.index('tabTrigger')].gsub!('.','')}</tag>\r\n"
  snippet += "    <description>#{arrString[arrKey.index('name')]}</description>\r\n"
  snippet += "    <text><![CDATA[#{arrString[arrKey.index('content')]}]]></text>\r\n"
  snippet += "  </snippet>\r\n"

end

output = ""
output += "<?xml version='1.0' encoding='utf-8'?>
<snippets language=\"[LANGUAGE]\">\r\n"
for file in Dir.glob("Snippets/*.tmSnippet")
  puts "Converting #{file} ..."
  output += convert(file)
end
output += "</snippets>"

File.open("result.xml", "w") do |f|
  f.write(output)
end

puts "**** Done, result stored in result.xml, don't forget to change the [language] value ****"

