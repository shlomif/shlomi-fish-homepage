upload_vipe: $(VIPE_TARGETS)
	( cd $(VIPE_DEST) && $(RSYNC) -r * shlomif@vipe.technion.ac.il:public_html/ )

upload_vipe_alt: $(VIPE_TARGETS)
	( cd $(VIPE_DEST) && $(RSYNC) -r * $${HOMEPAGE_SSH_PATH}/Vipe/ )

