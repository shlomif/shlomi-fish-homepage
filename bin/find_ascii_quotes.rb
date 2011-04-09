require 'rubygems'
require 'nokogiri'

ARGV.each do |filename|
    xml_stream = File.open(filename)
    reader = Nokogiri::XML::Reader(xml_stream)
    titles = []
    text = ''
    grab_text = false
    reader.each do |elem|
        if elem.node_type == Nokogiri::XML::Node::TEXT_NODE
            data = elem.value
            lines = data.split(/\n/, -1);
            
            lines.each_with_index do |line, idx|
                if (line =~ /"/) then
                    STDOUT.printf "%s:%d:%s\n", filename, elem.line()+idx, line
                end
            end
        end
    end
end
