require 'asciidoctor'

Asciidoctor.convert_file('README.adoc', :in_place => true, :to_file => 'index.html')
