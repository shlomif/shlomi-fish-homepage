PRINTABLE_DEST_DIR := dest/printable
PRINTABLE_RESUMES__HTML__PIVOT := $(PRINTABLE_DEST_DIR)/Shlomi-Fish-English-Resume-Detailed.html
PRINTABLE_RESUMES__HTML := $(PRINTABLE_RESUMES__HTML__PIVOT) $(addprefix $(PRINTABLE_DEST_DIR)/,Shlomi-Fish-English-Resume.html Shlomi-Fish-Heb-Resume.html Shlomi-Fish-Resume-as-Software-Dev.html)

printable_resumes__html : $(PRINTABLE_RESUMES__HTML__PIVOT)

PRINTABLE_RESUMES__DOCX := $(patsubst %.html,%.docx,$(PRINTABLE_RESUMES__HTML))

$(PRINTABLE_RESUMES__DOCX): %.docx: %.html
	libreoffice --writer --headless --convert-to docx --outdir $(PRINTABLE_DEST_DIR) $<

$(PRINTABLE_RESUMES__HTML__PIVOT): $(PRE_DEST)/SFresume.html $(PRE_DEST)/SFresume_detailed.html $(PRE_DEST)/me/resumes/Shlomi-Fish-Heb-Resume.html $(PRE_DEST)/me/resumes/Shlomi-Fish-Resume-as-Software-Dev.html
	bash bin/gen-printable-CVs.sh
	cp -f $(PRINTABLE_DEST_DIR)/SFresume.html $(PRINTABLE_DEST_DIR)/Shlomi-Fish-English-Resume.html
	cp -f $(PRINTABLE_DEST_DIR)/SFresume_detailed.html $(PRINTABLE_DEST_DIR)/Shlomi-Fish-English-Resume-Detailed.html

resumes: $(PRINTABLE_RESUMES__DOCX)
