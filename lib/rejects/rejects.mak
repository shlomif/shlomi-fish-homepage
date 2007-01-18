upload_vipe: $(VIPE_TARGETS)
	( cd $(VIPE_DEST) && $(RSYNC) -r * shlomif@vipe.technion.ac.il:public_html/ )

upload_t2_temp: $(T2_TARGETS)
	( cd $(T2_DEST) && $(RSYNC) -r * shlomif@iglu.org.il:Home-Site/__New-Site/shlomif/ )

upload_vipe_temp: $(VIPE_TARGETS)
	( cd $(VIPE_DEST) && $(RSYNC) -r * shlomif@iglu.org.il:Home-Site/__New-Site/vipe/ )

upload_vipe_alt: $(VIPE_TARGETS)
	( cd $(VIPE_DEST) && $(RSYNC) -r * $${HOMEPAGE_SSH_PATH}/Vipe/ )

