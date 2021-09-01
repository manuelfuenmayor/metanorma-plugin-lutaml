k = {"visibility"=>"public", "name"=>nil, "xmi_id"=>"EAID_0BD8DEDF_F024_453d_AA7D_6EBC873FDBB6", "member_end"=>"AbstractFeatureWithLifespan", "member_end_type"=>"inheritance", "member_end_cardinality"=>{"min"=>nil, "max"=>""},"}, "member_end_attribute_name"=>nil, "owner_end"=>"AbstractCityObject", "definition"=>""}{"visibility"=>"public", "name"=>nil, "xmi_id"=>"EAID_1C91D9CF_14CB_400c_A818_7C74428AE5B7", "member_end"=>"AbstractAppearance", "member_end_type"=>"aggregation", "member_end_cardinality"=>{"min"=>"M", "max"=>" "member_end_attribute_name"=>"appearance", "owner_end"=>"AbstractCityObject", "definition"=>"Relates appearances to the city object."}{"visibility"=>"public", "name"=>nil, "xmi_id"=>"EAID_BDD0FCAB_72F7_499b_AC4D_2391D4DE7CAC", "member_end"=>"AbstractGenericAttribute", "member_end_type"=>"aggregation", "member_end_cardinality"=>{"min"=>"M", "max"=>""},"}, "member_end_attribute_name"=>"genericAttribute", "owner_end"=>"AbstractCityObject", "definition"=>"Relates generic attributes to the city object."}{"visibility"=>"public", "name"=>nil, "xmi_id"=>"EAID_C22B8769_C2E7_4e9b_9C0D_138631E90002", "member_end"=>"AbstractCityObject", "member_end_type"=>"aggregation", "member_end_cardinality"=>{"min"=>"M", "max"=>" "member_end_attribute_name"=>"generalizesTo", "owner_end"=>"AbstractCityObject", "definition"=>"Relates generalized representations of the same real-world object in different Levels of Detail to the city object. The direction of this relation is from the city object to the corresponding generalized city objects."}{"visibility"=>"public", "name"=>nil, "xmi_id"=>"EAID_CF0045E1_6BF1_40a7_B08D_9B7B30ECA025", "member_end"=>"ExternalReference", "member_end_type"=>"aggregation", "member_end_cardinality"=>{"min"=>"M", "max"=>""},"}, "member_end_attribute_name"=>"externalReference", "owner_end"=>"AbstractCityObject", "definition"=>"References external objects in other information systems that have a relation to the city object."}{"visibility"=>"public", "name"=>nil, "xmi_id"=>"EAID_D45045CA_AAD6_418a_AF10_F4BC95DE923A", "member_end"=>"AbstractCityObject", "member_end_type"=>"aggregation", "member_end_cardinality"=>{"min"=>"M", "max"=>" "member_end_attribute_name"=>"relatedTo", "owner_end"=>"AbstractCityObject", "definition"=>"Relates other city objects to the city object. It also describes how the city objects are related to each other."}{"visibility"=>"public", "name"=>nil, "xmi_id"=>"EAID_E3BB8700_143D_4dbd_A7EC_49D33C66D430", "member_end"=>"AbstractDynamizer", "member_end_type"=>"aggregation", "member_end_cardinality"=>{"min"=>"M", "max"=>""},"}, "member_end_attribute_name"=>"dynamizer", "owner_end"=>"AbstractCityObject", "definition"=>"Relates Dynamizer objects to the city object. These allow timeseries data to override static attribute values of the city object."}{"visibility"=>"public", "name"=>nil, "owner_end"=>"AbstractCityObject"}{"visibility"=>"public", "name"=>nil, "xmi_id"=>"EAID_BE026036_E811_494c_9776_D1A309393D6D", "member_end"=>"AbstractSpace", "member_end_type"=>"generalization", "member_end_cardinality"=>nil, "member_end_attribute_name"=>nil, "owner_end"=>"AbstractCityObject", "definition"=>""}{"visibility"=>"public", "name"=>nil, "xmi_id"=>"EAID_C2189DFF_0F24_475b_AB55_070CD09A3186", "member_end"=>"AbstractSpaceBoundary", "member_end_type"=>"generalization", "member_end_cardinality"=>{"min"=>nil, "max"=>" "member_end_attribute_name"=>nil, "owner_end"=>"AbstractCityObject", "definition"=>""}{"visibility"=>"public", "name"=>nil, "xmi_id"=>"EAID_C22B8769_C2E7_4e9b_9C0D_138631E90002", "member_end"=>"AbstractCityObject", "member_end_type"=>"aggregation", "member_end_cardinality"=>{"min"=>"M", "max"=>""},"}, "member_end_attribute_name"=>"generalizesTo", "owner_end"=>"AbstractCityObject", "definition"=>"Relates generalized representations of the same real-world object in different Levels of Detail to the city object. The direction of this relation is from the city object to the corresponding generalized city objects."}{"visibility"=>"public", "name"=>nil, "xmi_id"=>"EAID_D45045CA_AAD6_418a_AF10_F4BC95DE923A", "member_end"=>"AbstractCityObject", "member_end_type"=>"aggregation", "member_end_cardinality"=>{"min"=>"M", "max"=>" "member_end_attribute_name"=>"relatedTo", "owner_end"=>"AbstractCityObject", "definition"=>"Relates other city objects to the city object. It also describes how the city objects are related to each other."}{"visibility"=>"public", "name"=>nil, "owner_end"=>"AbstractCityObject"}{"visibility"=>"public", "name"=>nil, "owner_end"=>"AbstractCityObject"}