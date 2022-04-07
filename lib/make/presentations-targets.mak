LC_PRES_PATH := lecture/Lambda-Calculus/slides

LC_PRES_SCMS := \
	cond_funcs_loops.scm \
	cond.scm \
	funcs.scm \
	lc_bool_ops.scm \
	lc_bools_conds_tuples.scm \
	lc_church_div_old.scm \
	lc_church_div.scm \
	lc_church_ops.scm \
	lc_church.scm \
	lc_constructs.scm \
	lc_intro.scm \
	lc_recursion.scm \
	lc_Y.scm \
	lists.scm \
	loops.scm \
	notes.scm \
	output_vars.scm \
	shriram.scm \

LC_PRES_SRC_DIR := $(SRC_SRC_DIR)/$(LC_PRES_PATH)
LC_PRES_DEST := $(PRE_DEST)/$(LC_PRES_PATH)

LC_PRES_SRC_SCMS := $(patsubst %,$(LC_PRES_SRC_DIR)/%,$(LC_PRES_SCMS))
LC_PRES_DEST_HTMLS__PIVOT := $(patsubst %.scm,$(LC_PRES_DEST)/%.scm.html,notes.scm)

lc_pres_targets: $(LC_PRES_DEST_HTMLS__PIVOT)

# Uses text-vimcolor from http://search.cpan.org/dist/Text-VimColor/
$(LC_PRES_DEST_HTMLS__PIVOT): $(LC_PRES_SRC_SCMS)
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/text-vimcolor-multi.pl $(LC_PRES_SRC_DIR) $(LC_PRES_DEST)

SPORK_LECTURES_BASENAMES := \
	Perl/Graham-Function \
	Perl/Lightning/Opt-Multi-Task-in-PDL \
	Perl/Lightning/Test-Run \
	Perl/Lightning/Too-Many-Ways \
	SCM/subversion/for-pythoneers \
	Vim/beginners \

START_html := /start.html
SLIDES_start := /slides$(START_html)
SPORK_LECTS_SOURCE_BASE := lib/presentations/spork
GFUNC_PRES_BASE := $(SPORK_LECTS_SOURCE_BASE)/Perl/Graham-Function
GFUNC_PRES_DEST := $(PRE_DEST)/lecture/Perl/Graham-Function
GFUNC_PRES_BASE_START := $(GFUNC_PRES_BASE)$(SLIDES_start)
GFUNC_PRES_DEST_START := $(GFUNC_PRES_DEST)$(SLIDES_start)

SPORK_LECTURES_DESTS := $(addprefix $(PRE_DEST)/lecture/,$(SPORK_LECTURES_BASENAMES))
SPORK_LECTURES_DEST_STARTS := $(addsuffix $(SLIDES_start),$(SPORK_LECTURES_DESTS))
SPORK_LECTURES_BASE_STARTS := $(patsubst %,$(SPORK_LECTS_SOURCE_BASE)/%$(SLIDES_start),$(SPORK_LECTURES_BASENAMES))

SPORK_test_run_dir := $(SPORK_LECTS_SOURCE_BASE)/Perl/Lightning/Test-Run/slides/images
SPORK_LECTS_SOURCE_DOWNLOADED_IMAGES__test_run := $(SPORK_test_run_dir)/screenshot02.png \
	$(SPORK_test_run_dir)/Test-Run-Plugin-ColorSummary.png

SPORK_too_many_ways_dir := $(SPORK_LECTS_SOURCE_BASE)/Perl/Lightning/Too-Many-Ways/slides/images
SPORK_LECTS_SOURCE_DOWNLOADED_IMAGES__too_many := \
	$(SPORK_too_many_ways_dir)/coachella-crowd.jpg \
	$(SPORK_too_many_ways_dir)/coachella-crowd.webp \
	$(SPORK_too_many_ways_dir)/bono.jpg \
	$(SPORK_too_many_ways_dir)/TestBeforeYouTouchCARD.jpg

src/images/presentations/coachella-crowd.webp: %.webp: %.jpg
	$(call simple_gm)

SPORK_LECTS_SOURCE_DOWNLOADED_IMAGES := $(SPORK_LECTS_SOURCE_DOWNLOADED_IMAGES__too_many) $(SPORK_LECTS_SOURCE_DOWNLOADED_IMAGES__test_run)

presentations_targets: $(SPORK_LECTURES_DEST_STARTS)

start_html = $(patsubst %$(START_html),%/,$1)

$(SPORK_LECTURES_DEST_STARTS) : $(PRE_DEST)/lecture/%$(START_html): $(SPORK_LECTS_SOURCE_BASE)/%$(START_html)
	rsync -a $(call start_html,$<) $(call start_html,$@)

$(SPORK_LECTURES_BASE_STARTS) : $(SPORK_LECTS_SOURCE_BASE)/%$(SLIDES_start) : $(SPORK_LECTS_SOURCE_BASE)/%/Spork.slides $(SPORK_LECTS_SOURCE_BASE)/%/config.yaml $(SPORK_LECTS_SOURCE_DOWNLOADED_IMAGES)
	dn="$(patsubst %$(SLIDES_start),%,$@)" ; \
	   (cd "$$dn" && $(PERL) $(LATEMP_ABS_ROOT_SOURCE_DIR)/bin/my-spork.pl -- -make) && \
	cp -f common/favicon.png $(patsubst %$(START_html),%,$@)/

lib/presentations/spork/Vim/beginners/Spork.slides: lib/presentations/spork/Vim/beginners/Spork.slides.source
	< $< $(PERL) -pe 's!^\+!!' > $@
