ifeq ($(UPLOAD_MATHJAX),1)
	RSYNC_EXCLUDES :=
else
	RSYNC_EXCLUDES := --exclude='**/js/MathJax/**'
endif

# UPLOAD = (cd $(POST_DEST) && $(RSYNC) $(RSYNC_EXCLUDES) -a . $1 )
UPLOAD_BRIEF = (cd $(POST_DEST) && $(RSYNC) --no-progress --no-verbose $(RSYNC_EXCLUDES) -a . $1 )
UPLOAD = $(UPLOAD_BRIEF)

upload_deps: all

upload_local: upload_deps
	$(call UPLOAD,$${HOMEPAGE_SSH_PATH})

upload: upload_local upload_remote_only

upload_remote_only: upload_deps
	$(call UPLOAD_BRIEF,$${__HOMEPAGE_REMOTE_PATH})

upload_remote_only_without_deps:
	$(call UPLOAD_BRIEF,$${__HOMEPAGE_REMOTE_PATH})

upload_var: upload_deps upload_var_without_deps

upload_var_without_deps:
	$(call UPLOAD,/var/www/html/shlomif/homepage-local/)

upload_beta: upload_deps
	$(call UPLOAD_BRIEF,$${__HOMEPAGE_REMOTE_PATH}/__Beta-kmor)

upload_beta2: upload_deps
	$(call UPLOAD_BRIEF,$${__HOMEPAGE_REMOTE_PATH}/__Beta-aj2del)

upload_all: upload upload_var upload_local upload_beta

upload_hostgator: upload_deps
	$(call UPLOAD,'hostgator:public_html/')

