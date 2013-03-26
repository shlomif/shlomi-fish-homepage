all:

DIRS = \
	chromaticd \
	CPP-supports-OOP \
	dont-believe-in-fairies \
	give-me-ascii  \
	lottery-all-you-need-is-a-dollar \


upload:
	rsync -v --progress -a --rsh=ssh $$(find $(DIRS) -name '*.svg' -o -name '*.png' -o -name '*.xcf' -o -name '*.xcf.bz2') "$${HOMEPAGE_SSH_PATH}"/Files/files/images/graphic-art/
