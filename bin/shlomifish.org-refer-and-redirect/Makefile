REMOTE_PATH = rag:shlomifish.org/public_html

all:

upload:
	rsync -a -v --progress sf.org-refer.pl $(REMOTE_PATH)/
	rsync -a -v --progress htaccess $(REMOTE_PATH)/.htaccess
