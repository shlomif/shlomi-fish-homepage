htacc = $(addsuffix /.htaccess,$(1))
SRC_FORTUNES_DIR_HTACCESS := $(call htacc,$(PRE_DEST_FORTUNES_DIR))

ALL_HTACCESSES := $(call htacc,$(PRE_DEST_FORTUNES_DIR) $(addprefix $(PRE_DEST)/,art lecture/PostgreSQL-Lecture philosophy/culture philosophy/culture/case-for-commercial-fan-fiction))

htaccesses_target: $(ALL_HTACCESSES)

$(SRC_FORTUNES_DIR)/my_htaccess.conf: $(SRC_FORTUNES_DIR)/gen-htaccess.pl
	(cd $(SRC_FORTUNES_DIR) && $(GNUMAKE))
