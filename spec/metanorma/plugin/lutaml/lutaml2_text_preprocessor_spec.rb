require "spec_helper"

RSpec.describe Metanorma::Plugin::Lutaml::LutamlPreprocessor do
  describe "#process" do
    let(:example_file) { fixtures_path("test_relative_includes_svgmap.exp") }

    context "Array of hashes" do
      let(:input) do
        <<~TEXT
          = Document title
          Author
          :docfile: test.adoc
          :nodoc:
          :novalid:
          :no-isobib:
          :imagesdir: spec/assets

          [lutaml,#{example_file},my_context]
          ----

          == {{my_context.id}}

          {% for entity in my_context.entities %}
          === {{entity.id}}
          supertypes -> {{entity.supertypes.id}}
          explicit -> {{entity.explicit.first.id}}

          {% endfor %}
          ----
        TEXT
      end
      let(:output) do
        <<~TEXT
          #{BLANK_HDR}
          <sections>
          <clause id="_" inline-header="false" obligation="normative"><title>annotated_3d_model_data_quality_criteria_schema</title>
          <clause id="_" inline-header="false" obligation="normative">
          <title>a3m_data_quality_criteria_representation</title>
          <p id="_">supertypes →
          explicit → </p>
          </clause>
          <clause id="_" inline-header="false" obligation="normative">
          <title>a3m_data_quality_criterion</title>
          <p id="_">supertypes →
          explicit → </p>
          </clause>
          <clause id="_" inline-header="false" obligation="normative">
          <title>a3m_data_quality_criterion_specific_applied_value</title>
          <p id="_">supertypes →
          explicit → </p>
          </clause>
          <clause id="_" inline-header="false" obligation="normative">
          <title>a3m_data_quality_target_accuracy_association</title>
          <p id="_">supertypes →
          explicit → </p>
          </clause>
          <clause id="_" inline-header="false" obligation="normative">
          <title>a3m_detailed_report_request</title>
          <p id="_">supertypes →
          explicit → </p>
          </clause>
          <clause id="_" inline-header="false" obligation="normative">
          <title>a3m_summary_report_request_with_representative_value</title>
          <p id="_">supertypes →
          explicit → </p>
          </clause></clause>
          </sections>
          </standard-document>
          </body></html>
        TEXT
      end

      it "correctly renders input" do
        expect(xml_string_conent(metanorma_process(input)))
          .to(be_equivalent_to(output))
      end
    end

    context "when additional options passed" do
      let(:input) do
        <<~TEXT
          = Document title
          Author
          :docfile: test.adoc
          :nodoc:
          :novalid:
          :no-isobib:
          :imagesdir: spec/assets
          [lutaml,#{example_file},schema, leveloffset=+2]
          ----

          == {{schema.id}}

          {% for remark in schema.remarks %}
          {{ remark }}
          {% endfor %}

          ----


          [lutaml,#{example_file},schema, leveloffset=-1]
          ----

          == {{schema.id}}

          {% for remark in schema.remarks %}
          {{ remark }}
          {% endfor %}
          ----
        TEXT
      end

      let(:output) do
        <<~TEXT
          #{BLANK_HDR}
            <sections><clause id="_" inline-header="false" obligation="normative"><title>annotated_3d_model_data_quality_criteria_schema</title>
            <p id="_">Mine text</p>
            <svgmap id="_"><figure id="_">
            <image src="#{File.expand_path(fixtures_path("measure_schemaexpg5.svg"))}" id="_" mimetype="image/svg+xml" height="auto" width="auto"></image>
            </figure><target href="1"><eref bibitemid="express_measure_schema" citeas="">measure_schema</eref></target><target href="2"><eref bibitemid="express_measure_schemaexpg4" citeas="">measure_schemaexpg4</eref></target><target href="3"><eref bibitemid="express_measure_schema" citeas="">measure_schema</eref></target></svgmap></clause>
            <clause id="_" inline-header="false" obligation="normative"><title>annotated_3d_model_data_quality_criteria_schema</title>
            <p id="_">Mine text</p>
            <p id="_">===
            image::#{File.expand_path(fixtures_path("measure_schemaexpg5.svg"))}[]</p>
            <ul id="_">
            <li>
            <p id="_"><eref bibitemid="express_measure_schema" citeas="">measure_schema</eref>; 1</p>
            </li>
            <li>
            <p id="_"><eref bibitemid="express_measure_schemaexpg4" citeas="">measure_schemaexpg4</eref>; 2</p>
            </li>
            <li>
            <p id="_"><eref bibitemid="express_measure_schema" citeas="">measure_schema</eref>; 3
            ===</p>
            </li>
            </ul></clause></sections>
            <bibliography><references hidden="true" normative="false"><bibitem id="express_measure_schema" type="internal">
            <docidentifier type="repository">express/measure_schema</docidentifier>
            </bibitem>
            <bibitem id="express_measure_schemaexpg4" type="internal">
            <docidentifier type="repository">express/measure_schemaexpg4</docidentifier>
            </bibitem>
            </references></bibliography></standard-document>
          </body></html>
        TEXT
      end

      it "correctly renders input" do
        expect(xml_string_conent(metanorma_process(input)))
          .to(be_equivalent_to(output))
      end
    end

    context "when relative paths exists in doc" do
      let(:example_file) { fixtures_path("test_relative_includes.exp").gsub(FileUtils.pwd, '')[1..-1] }
      let(:input) do
        <<~TEXT
          = Document title
          Author
          :docfile: test.adoc
          :nodoc:
          :novalid:
          :no-isobib:
          :imagesdir: spec/assets

          [lutaml,#{example_file},schema]
          ----
          == {{schema.id}}

          {% for remark in schema.remarks %}
          {{ remark }}
          {% endfor %}
          ----
        TEXT
      end
      let(:doc_path) { File.dirname(example_file) }
      let(:output) do
        <<~TEXT
          #{BLANK_HDR}
          <sections>
            <clause id="_" inline-header="false" obligation="normative"><title>annotated_3d_model_data_quality_criteria_schema</title>
            <p id="_">Mine text</p>
            <p id="_">
            <link target="#{fixtures_path('/downloads/report.pdf')}">Get Report
            </p>
            <p id="_">
            <link target="http://test.com/include1.csv">
            </p>


            <p id="_">include::#{fixtures_path('/include1.csv')}[]</p>
            <p id="_">include::#{fixtures_path('test/include1.csv')}[]</p>
            <p id="_">include::http://test.com/include1.csv[]</p>
            </clause>
          </sections>
          </standard-document>
          </body></html>
        TEXT
      end

      it "correctly renders input" do
        expect(xml_string_conent(metanorma_process(input)))
          .to(be_equivalent_to(output))
      end
    end

    context "when svgmap anchors are used" do
      let(:example_file) { fixtures_path("test_relative_includes_svgmap.exp").gsub(FileUtils.pwd, '')[1..-1] }
      let(:input) do
        <<~TEXT
          = Document title
          Author
          :docfile: test.adoc
          :nodoc:
          :novalid:
          :no-isobib:
          :imagesdir: spec/assets

          [lutaml,#{example_file},schema]
          ----
          == {{schema.id}}

          {% for remark in schema.remarks %}
          {{ remark }}
          {% endfor %}
          ----
        TEXT
      end
      let(:doc_path) { File.dirname(example_file) }
      let(:output) do
        <<~TEXT
          #{BLANK_HDR}
          <sections>
            <clause id="_" inline-header="false" obligation="normative">
              <title>annotated_3d_model_data_quality_criteria_schema</title>
              <p id="_">Mine text</p>
              <svgmap id="_">
                <figure id="_">
                  <image src="#{File.expand_path(fixtures_path('measure_schemaexpg5.svg'))}" id="_" mimetype="image/svg+xml"
                    height="auto" width="auto"></image>
                </figure>
                <target href="1">
                  <eref bibitemid="express_measure_schema" citeas="">measure_schema</eref>
                </target>
                <target href="2">
                  <eref bibitemid="express_measure_schemaexpg4" citeas="">measure_schemaexpg4</eref>
                </target>
                <target href="3">
                  <eref bibitemid="express_measure_schema" citeas="">measure_schema</eref>
                </target>
              </svgmap>
            </clause>
          </sections>
          <bibliography><references hidden="true" normative="false"><bibitem id="express_measure_schema" type="internal">
          <docidentifier type="repository">express/measure_schema</docidentifier>
          </bibitem>
          <bibitem id="express_measure_schemaexpg4" type="internal">
          <docidentifier type="repository">express/measure_schemaexpg4</docidentifier>
          </bibitem>
          </references></bibliography>
          </standard-document>
          </body>

          </html>
        TEXT
      end

      it "correctly renders input" do
        expect(xml_string_conent(metanorma_process(input)))
          .to(be_equivalent_to(output))
      end
    end


    context "when lutaml-express-index keyword used with folder path" do
      let(:cache_file_path) { fixtures_path('express_temp_cache.yaml') }
      let(:input) do
        <<~TEXT
          = Document title
          Author
          :docfile: test.adoc
          :nodoc:
          :novalid:
          :no-isobib:
          :imagesdir: spec/assets
          :lutaml-express-index: first-express-set; #{fixtures_path('expressir_index_1')};
          :lutaml-express-index: second-express-set; #{fixtures_path('expressir_index_2')}; cache=#{cache_file_path}

          [lutaml,first-express-set,schema]
          ----
          == {{schema.id}}
          ----

          [lutaml,second-express-set,schema]
          ----
          == {{schema.id}}
          ----
        TEXT
      end
      let(:output) do
        <<~TEXT
          #{BLANK_HDR}
          <sections>
            <clause id="_" inline-header="false" obligation="normative">
              <title>Activity_method_assignment_arm</title>
            </clause>
            <clause id="_" inline-header="false" obligation="normative">
              <title>Activity_method_assignment_mim</title>
            </clause>
            <clause id="_" inline-header="false" obligation="normative">
              <title>Activity_method_assignment_arm</title>
            </clause>
            <clause id="_" inline-header="false" obligation="normative">
              <title>Activity_method_characterized_arm</title>
            </clause>
            <clause id="_" inline-header="false" obligation="normative">
              <title>Activity_method_characterized_mim</title>
            </clause>
          </sections>
          </standard-document>
          </body></html>
        TEXT
      end

      around do |example|
        FileUtils.rm_rf(cache_file_path)
        example.run
        FileUtils.rm_rf(cache_file_path)
      end

      it "correctly renders input" do
        expect(xml_string_conent(metanorma_process(input)))
          .to(be_equivalent_to(output))
      end

      it "creates a valid cache file for supplied path" do
        expect { metanorma_process(input) }
          .to(change { File.file?(cache_file_path) }.from(false).to(true))
        expect(::Lutaml::Parser.parse(File.new(cache_file_path),
                Lutaml::Parser::EXPRESS_CACHE_PARSE_TYPE).map {|n| n.to_liquid.map { |j| j["id"] }})
              .to(eq([["Activity_method_characterized_arm", "Activity_method_characterized_mim"]]))
      end
    end

    context "when lutaml-express-index keyword used with folder path and cache" do
      let(:input) do
        <<~TEXT
          = Document title
          Author
          :docfile: test.adoc
          :nodoc:
          :novalid:
          :no-isobib:
          :imagesdir: spec/assets
          :lutaml-express-index: first-express-set; #{fixtures_path('expressir_index_1')};
          :lutaml-express-index: second-express-set; #{fixtures_path('expressir_index_2')};

          [lutaml,first-express-set,schema]
          ----
          == {{schema.id}}
          ----

          [lutaml,second-express-set,schema]
          ----
          == {{schema.id}}
          ----
        TEXT
      end
      let(:output) do
        <<~TEXT
          #{BLANK_HDR}
          <sections>
            <clause id="_" inline-header="false" obligation="normative">
              <title>Activity_method_assignment_arm</title>
            </clause>
            <clause id="_" inline-header="false" obligation="normative">
              <title>Activity_method_assignment_mim</title>
            </clause>
            <clause id="_" inline-header="false" obligation="normative">
              <title>Activity_method_assignment_arm</title>
            </clause>
            <clause id="_" inline-header="false" obligation="normative">
              <title>Activity_method_characterized_arm</title>
            </clause>
            <clause id="_" inline-header="false" obligation="normative">
              <title>Activity_method_characterized_mim</title>
            </clause>
          </sections>
          </standard-document>
          </body></html>
        TEXT
      end

      it "correctly renders input" do
        expect(xml_string_conent(metanorma_process(input)))
          .to(be_equivalent_to(output))
      end
    end

    context "when multiply files supplied to macro" do
      let(:express_files_list) do
        [
          fixtures_path("test_relative_includes_svgmap.exp"),
          fixtures_path("expressir_index_1/arm_svgmap.exp"),
          fixtures_path("expressir_index_2/mim.exp"),
        ]
      end
      let(:input) do
        <<~TEXT
          = Document title
          Author
          :docfile: test.adoc
          :nodoc:
          :novalid:
          :no-isobib:
          :imagesdir: spec/assets

          [lutaml, #{express_files_list.join('; ')}, schema]
          ----
          == {{schema.id}}

          {% for remark in schema.remarks %}
          {{ remark }}
          {% endfor %}
          ----
        TEXT
      end
      let(:output) do
        <<~TEXT
          #{BLANK_HDR}
          <sections>
            <clause id="_" inline-header="false" obligation="normative">
              <title>annotated_3d_model_data_quality_criteria_schema</title>
              <p id="_">Mine text</p>
              <svgmap id="_">
                <figure id="_">
                  <image
                    src="#{File.expand_path(fixtures_path('measure_schemaexpg5.svg'))}"
                    id="_" mimetype="image/svg+xml" height="auto" width="auto"></image>
                </figure>
                <target
                  href="1">
                  <eref bibitemid="express_measure_schema" citeas="">measure_schema</eref>
                </target>
                <target
                  href="2">
                  <eref bibitemid="express_measure_schemaexpg4" citeas="">measure_schemaexpg4</eref>
                </target>
                <target
                  href="3">
                  <eref bibitemid="express_measure_schema" citeas="">measure_schema</eref>
                </target>
              </svgmap>
            </clause>
            <clause id="_" inline-header="false" obligation="normative">
              <title>Activity_method_assignment_arm</title>
              <p id="_">Mine text</p>
              <svgmap id="_">
                <figure id="_">
                  <image
                    src="#{File.expand_path(fixtures_path('expressir_index_1/measure_schemaexpg5.svg'))}"
                    id="_" mimetype="image/svg+xml" height="auto" width="auto"></image>
                </figure>
                <target
                  href="1">
                  <eref bibitemid="express_measure_schema" citeas="">measure_schema</eref>
                </target>
                <target
                  href="2">
                  <eref bibitemid="express_measure_schemaexpg4" citeas="">measure_schemaexpg4</eref>
                </target>
                <target
                  href="3">
                  <eref bibitemid="express_measure_schema" citeas="">measure_schema</eref>
                </target>
              </svgmap>
            </clause>
            <clause id="_" inline-header="false" obligation="normative">
              <title>Activity_method_characterized_mim</title>
            </clause>
          </sections>
          <bibliography><references hidden="true" normative="false"><bibitem id="express_measure_schema" type="internal">
          <docidentifier type="repository">express/measure_schema</docidentifier>
          </bibitem>
          <bibitem id="express_measure_schemaexpg4" type="internal">
          <docidentifier type="repository">express/measure_schemaexpg4</docidentifier>
          </bibitem>
          </references></bibliography>
          </standard-document>
          </body>

          </html>
        TEXT
      end

      it "correctly renders input" do
        expect(xml_string_conent(metanorma_process(input)))
          .to(be_equivalent_to(output))
      end
    end
  end
end
