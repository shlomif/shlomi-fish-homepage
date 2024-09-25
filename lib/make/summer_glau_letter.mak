OCT_2014_SGLAU_LET_DIR := $(SRC_SRC_DIR)/philosophy/SummerNSA/Letter-to-SGlau-2014-10
OCT_2014_SGLAU_LET_PDF := $(OCT_2014_SGLAU_LET_DIR)/letter-to-sglau.pdf
OCT_2014_SGLAU_LET_HTML := $(OCT_2014_SGLAU_LET_DIR)/letter-to-sglau.xhtml

non_latemp_targets: $(OCT_2014_SGLAU_LET_PDF) $(OCT_2014_SGLAU_LET_HTML)

$(OCT_2014_SGLAU_LET_PDF): $(SRC_SRC_DIR)/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.odt
	dir="$$PWD" ; cd $(OCT_2014_SGLAU_LET_DIR) && oowriter --headless --convert-to pdf "$${dir}/$<"

$(OCT_2014_SGLAU_LET_HTML): $(SRC_SRC_DIR)/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.odt
	dir="$$PWD" ; cd $(OCT_2014_SGLAU_LET_DIR) && oowriter --headless --convert-to xhtml "$${dir}/$<"
