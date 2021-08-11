require "spec_helper"

RSpec.describe Metanorma::Plugin::Lutaml::LutamlUmlDatamodelDescriptionPreprocessor do
  describe "#process" do
    let(:example_file) { fixtures_path("large_test.xmi") }
    let(:config_file) { fixtures_path("lutaml_uml_datamodel_description_config.yml") }

    context "when there is an options file" do
      let(:input) do
        <<~TEXT
          = Document title
          Author
          :docfile: test.adoc
          :nodoc:
          :novalid:
          :no-isobib:
          :imagesdir: spec/assets

          [lutaml_uml_datamodel_description,#{example_file},#{config_file}]
          --
          [.diagram_include_block, base_path="requirements/"]
          ...
          Diagram text
          ...

          [.include_block, package="Another", base_path="spec/fixtures/"]
          ...
          my text
          ...

          [.include_block, base_path="spec/fixtures/"]
          ...
          my text
          ...

          [.before]
          ...
          mine text
          ...

          [.before, package="Another"]
          ...
          text before Another package
          ...

          [.after, package="Another"]
          ...
          text after Another package
          ...

          [.after, package="CityGML"]
          ...
          text after CityGML package
          ...

          [.after]
          ...
          footer text
          ...
          --
        TEXT
      end
      let(:output) do
        <<~TEXT
          #{BLANK_HDR}
          #{File.read(fixtures_path('datamodel_description_sections.xml'))}
          </standard-document>
          </body></html>
        TEXT
      end

      it "correctly renders input" do
        expect(xml_string_conent(metanorma_process(input)))
          .to(be_equivalent_to(output))
      end
    end

    context "when there is no options file" do
      let(:input) do
        <<~TEXT
          = Document title
          Author
          :docfile: test.adoc
          :nodoc:
          :novalid:
          :no-isobib:
          :imagesdir: spec/assets

          [lutaml_uml_datamodel_description,#{example_file}]
          --
          [.diagram_include_block, base_path="requirements/"]
          ...
          Diagram text
          ...

          [.include_block, package="Another", base_path="spec/fixtures/"]
          ...
          my text
          ...

          [.include_block, base_path="spec/fixtures/"]
          ...
          my text
          ...

          [.before]
          ...
          mine text
          ...

          [.before, package="Another"]
          ...
          text before Another package
          ...

          [.after, package="Another"]
          ...
          text after Another package
          ...

          [.after, package="CityGML"]
          ...
          text after CityGML package
          ...

          [.after]
          ...
          footer text
          ...
          --
        TEXT
      end
      let(:output) do
        <<~TEXT
          #{BLANK_HDR}
          #{File.read(fixtures_path('datamodel_description_sections_tree.xml'))}
          </standard-document>
          </body></html>
        TEXT
      end

      it "correctly renders input" do
        expect(xml_string_conent(metanorma_process(input)))
          .to(be_equivalent_to(output))
      end
    end
  end
end
