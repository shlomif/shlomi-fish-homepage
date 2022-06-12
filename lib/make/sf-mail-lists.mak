MLARCHIVE_DEST_DIR_c := $(POST_DEST)/mail-lists/hackers-il
MLARCHIVE_DEST_DIR_bn := archive
MLARCHIVE_DEST_DIR := $(MLARCHIVE_DEST_DIR_c)/$(MLARCHIVE_DEST_DIR_bn)
MLARCHIVE_DEST_pivot := $(MLARCHIVE_DEST_DIR)/index.html
EMPTYFOOTER := $(PWD)/lib/emptyfooter.hyp

$(MLARCHIVE_DEST_pivot): $(PWD)/lib/data/mbox/hackers-il/h.mbox
	mkdir -p $(MLARCHIVE_DEST_DIR_c)
	( cd $(MLARCHIVE_DEST_DIR_c) && hypermail -o ihtmlfooterfile=$(EMPTYFOOTER) -o mhtmlfooterfile=$(EMPTYFOOTER) -o usegdbm=1 -o mbox_shortened=1 -d $(MLARCHIVE_DEST_DIR_bn) < $< )
	$(PERL) -lp -i $(PWD)/bin/hypermail-post-proc.pl $(MLARCHIVE_DEST_DIR)/{attachment.html,author.html,date.html,index.html,subject.html}
	find $(MLARCHIVE_DEST_DIR_c) -print | xargs touch -d 2021-10-12T10:20:00Z

ml_archive: $(MLARCHIVE_DEST_pivot)

non_latemp_targets: ml_archive
