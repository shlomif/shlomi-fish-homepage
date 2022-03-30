JSON_RES_BASE := me/resumes/Shlomi-Fish-Resume.jsonresume

JSON_RES_DEST := $(POST_DEST)/$(JSON_RES_BASE).json

$(JSON_RES_DEST): $(SRC_SRC_DIR)/$(JSON_RES_BASE).yaml
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/my-yaml-2-canonical-json.pl -i $< -o $@

non_latemp_targets: $(JSON_RES_DEST)
