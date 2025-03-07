require "bundler/setup"
require "asciidoctor"
require "metanorma-plugin-lutaml"

# Register lutaml blocks as first preprocessors in line in order
# to test properly with metanorma-standoc
Asciidoctor::Extensions.register do
  inline_macro Metanorma::Plugin::Lutaml::LutamlTableInlineMacro, :lutaml_table
  inline_macro Metanorma::Plugin::Lutaml::LutamlFigureInlineMacro, :lutaml_figure
  preprocessor Metanorma::Plugin::Lutaml::LutamlUmlDatamodelDescriptionPreprocessor
end

require "metanorma-standoc"
require "rspec/matchers"
require "equivalent-xml"
require "metanorma"
require "metanorma/standoc"
require "rexml/document"
require "byebug"

Dir[File.expand_path("./support/**/**/*.rb", __dir__)].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

BLANK_HDR = <<~"HDR".freeze
  <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
  <?xml version="1.0" encoding="US-ASCII"?><html><body>
  <standard-document xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Standoc::VERSION}">
  <bibdata type="standard">
  <title language="en" format="text/plain">Document title</title>



  <language>en</language>
  <script>Latn</script>
  <status>
  <stage>published</stage>
  </status>
  <copyright>
  <from>#{Time.new.year}</from>
  </copyright>
  <ext>
  <doctype>article</doctype>
  </ext>
  </bibdata>
HDR

def strip_guid(xml)
  xml
    .gsub(%r{ id="_[^"]+"}, ' id="_"')
    .gsub(%r{ target="_[^"]+"}, ' target="_"')
end

def xml_string_conent(xml)
  strip_guid(Nokogiri::HTML(xml).to_s)
end

def metanorma_process(input)
  Metanorma::Input::Asciidoc
    .new
    .process(input, "test.adoc", :standoc)
end

def fixtures_path(path)
  File.join(File.expand_path("./fixtures", __dir__), path)
end

def strip_src(xml)
  xml.gsub(/\ssrc="[^"]+"/, ' src="_"')
end
