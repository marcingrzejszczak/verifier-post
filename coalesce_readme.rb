#Taken from - https://github.com/asciidoctor/asciidoctor-extensions-lab/blob/master/scripts/asciidoc-coalescer.rb

source_file = File.join(File.dirname(__FILE__),'verifier-post.adoc')
output_file = File.join(File.dirname(__FILE__),'README.adoc')

require 'asciidoctor'
require 'optparse'

options = { attributes: [], output: '-' }
OptionParser.new do |opts|
  opts.banner = 'Usage: ruby asciidoc-coalescer.rb [OPTIONS] FILE'
  opts.on('-a', '--attribute key[=value]', 'A document attribute to set in the form of key[=value]') do |a|
    options[:attributes] << a
  end
  opts.on('-o', '--output FILE', 'Write output to FILE instead of stdout.') do |o|
    options[:output] = o
  end
end.parse!

#unless (source_file = ARGV.shift)
#  warn 'Please specify an AsciiDoc source file to coalesce.'
#  exit 1
#end

#unless (output_file = options[:output]) == '-'
#  if (output_file = File.expand_path output_file) == (File.expand_path source_file)
#    warn 'Source and output cannot be the same file.'
#    exit 1
#  end
#end

# NOTE first, resolve attributes defined at the end of the document header
# QUESTION can we do this in a single load?
doc = Asciidoctor.load_file source_file, safe: :unsafe, header_only: true, attributes: options[:attributes]
# NOTE quick and dirty way to get the attributes set or unset by the document header
header_attr_names = (doc.instance_variable_get :@attributes_modified).to_a
header_attr_names.each {|k| doc.attributes[%(#{k}!)] = '' unless doc.attr? k }
attrs = doc.attributes
attrs['allow-uri-read'] = true

doc = Asciidoctor.load_file source_file, safe: :unsafe, parse: false, attributes: doc.attributes
# FIXME also escape ifdef, ifndef, ifeval and endif directives
# FIXME do this more carefully by reading line by line; if input differs by output by leading backslash, restore original line
lines = doc.reader.read.gsub(/^include::(?=.*\[\]$)/m, '\\include::')

if output_file == '-'
  puts lines
else
  File.open(output_file, 'w') {|f| f.write lines }
end
Status API Training Shop Blog About
