prod_sync_inc = $(1)/include-me.html

PROD_SYND_MUSIC_DIR := $(LATEMP_ROOT_SOURCE_DIR)/lib/prod-synd/music
PROD_SYND_MUSIC_INC := $(call prod_sync_inc,$(PROD_SYND_MUSIC_DIR))

PROD_SYND_NON_FICTION_BOOKS_DIR := $(LATEMP_ROOT_SOURCE_DIR)/lib/prod-synd/non-fiction-books
PROD_SYND_NON_FICTION_BOOKS_INC := $(call prod_sync_inc,$(PROD_SYND_NON_FICTION_BOOKS_DIR))

PROD_SYND_FILMS_DIR := $(LATEMP_ROOT_SOURCE_DIR)/lib/prod-synd/films
PROD_SYND_FILMS_INC := $(call prod_sync_inc,$(PROD_SYND_FILMS_DIR))

$(PRE_DEST)/art/recommendations/music/index.xhtml: $(PROD_SYND_MUSIC_INC)

all_deps: $(PROD_SYND_MUSIC_INC)

GPERL = $(PERL) -I $(LATEMP_ROOT_SOURCE_DIR)/lib
GPERL_DEPS := $(LATEMP_ROOT_SOURCE_DIR)/lib/Shlomif/Homepage/Amazon/Obj.pm

$(PROD_SYND_MUSIC_INC) : $(PROD_SYND_MUSIC_DIR)/gen-prod-synd.pl $(SRC_SRC_DIR)/art/recommendations/music/shlomi-fish-music-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<

$(PRE_DEST)/philosophy/books-recommends/index.xhtml : $(PROD_SYND_NON_FICTION_BOOKS_INC)

all_deps : $(PROD_SYND_NON_FICTION_BOOKS_INC)

$(PROD_SYND_NON_FICTION_BOOKS_INC) : $(PROD_SYND_NON_FICTION_BOOKS_DIR)/gen-prod-synd.pl $(SRC_SRC_DIR)/philosophy/books-recommends/shlomi-fish-non-fiction-books-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<

$(PRE_DEST_HUMOUR)/recommendations/films/index.xhtml: $(PROD_SYND_FILMS_INC)

all_deps: $(PROD_SYND_FILMS_INC)

$(PROD_SYND_FILMS_INC) : $(PROD_SYND_FILMS_DIR)/gen-prod-synd.pl $(SRC_SRC_DIR)/humour/recommendations/films/shlomi-fish-films-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<
