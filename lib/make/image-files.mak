RINDOLF_IMAGES_POST_DEST := $(POST_DEST)/me/rindolf/images
GRIMMIE_IMAGES_POST_DEST := $(POST_DEST)/art/recommendations/music/online-artists/fan-pages/chris-grimmie/images

RPG_DICE_SET_SRC := $(RINDOLF_IMAGES_POST_DEST)/rpg-dice-set--on-nuc.webp
RPG_DICE_SET_DEST := $(RINDOLF_IMAGES_POST_DEST)/rpg-dice-set--on-nuc--thumb.webp

GRIMMIE_IMG_SRC := $(GRIMMIE_IMAGES_POST_DEST)/christina-grimmie--529031666.jpg
GRIMMIE_IMG_DEST := $(GRIMMIE_IMAGES_POST_DEST)/christina-grimmie--529031666-r.webp
MY_NAME_IS_RINDOLF_SRC := $(RINDOLF_IMAGES_POST_DEST)/my-name-is-rindolf.jpg
MY_NAME_IS_RINDOLF_DEST := $(RINDOLF_IMAGES_POST_DEST)/my-name-is-rindolf-200w.jpg

Shlomif_cutethulhu_SRC := common/images/shlomif-cutethulhu.webp
Shlomif_cutethulhu_DEST := $(POST_DEST)/images/shlomif-cutethulhu-small.webp
Shlomif_sglau_shirt_field_SRC := src/meta/self-photos/images/shlomif-w-sglau-shirt-at-the-field-IMG-1703.jpg
Shlomif_sglau_shirt_field_DEST := $(POST_DEST)/meta/self-photos/images/shlomif-w-sglau-shirt-at-the-field-IMG-1703.jpg-400px.webp
Shlomif_mlpfim_shirt_SRC := src/meta/self-photos/images/shlomif-mlp-fim-shirt-img_2781.jpg
Shlomif_mlpfim_shirt_DEST := $(POST_DEST)/meta/self-photos/images/shlomif-mlp-fim-shirt-img_2781.jpg-400px.webp
Evilphish_flipped_src := $(POST_DEST)/images/evilphish.png

DnD_lances_cartoon_DEST := $(POST_DEST)/art/d-and-d-cartoon--comparing-lances/d-and-d-cartoon-exported.webp

POST_DEST__HUMOUR_IMAGES := $(POST_DEST_HUMOUR)/images

MY_RPF_DEST_DIR := $(POST_DEST)/philosophy/culture/my-real-person-fan-fiction
MY_RPF_DEST_PIVOT := $(MY_RPF_DEST_DIR)/euler.webp

OPENLY_BIPOLAR_DEST_DIR := $(POST_DEST)/philosophy/psychology/why-openly-bipolar-people-should-not-be-medicated/
OPENLY_BIPOLAR_DEST_PIVOT := $(OPENLY_BIPOLAR_DEST_DIR)/alan_turing.webp

non_latemp_targets: image_files
image_files: $(MY_RPF_DEST_PIVOT) $(OPENLY_BIPOLAR_DEST_PIVOT)
image_files: $(MY_NAME_IS_RINDOLF_DEST)

MY_RPF_SRC_DIR := $(SUB_REPOS_BASE_DIR)/my-real-person-fan-fiction

$(MY_RPF_DEST_PIVOT): $(MY_RPF_SRC_DIR)/euler.webp
	cp -f $(MY_RPF_SRC_DIR)/*.webp $(MY_RPF_DEST_DIR)/

OPENLY_BIPOLAR_SRC_DIR := $(SUB_REPOS_BASE_DIR)/why-openly-bipolar-people-should-not-be-medicated

$(OPENLY_BIPOLAR_DEST_PIVOT): $(OPENLY_BIPOLAR_SRC_DIR)/alan_turing.webp
	cp -f $(OPENLY_BIPOLAR_SRC_DIR)/*.webp $(OPENLY_BIPOLAR_DEST_DIR)/

$(DnD_lances_cartoon_DEST): $(SRC_SRC_DIR)/art/d-and-d-cartoon--comparing-lances/d-and-d-cartoon-exported.png
	$(call simple_gm)

image_files: $(DnD_lances_cartoon_DEST)

Evilphish_flipped_dest := $(POST_DEST)/images/evilphish-flipped.png
POST_DEST_HTML_6_LOGO_PNG := $(POST_DEST_HUMOUR)/bits/HTML-6/HTML-6-logo.png
PRINTER_ICON_PNG := $(POST_DEST)/images/printer_icon.png
TWITTER_ICON_20_PNG := $(POST_DEST)/images/twitter-bird-light-bgs-20.png

$(GRIMMIE_IMG_DEST): $(GRIMMIE_IMG_SRC)
	$(IMAGE_CONVERT) -resize '200x' $< $@

$(MY_NAME_IS_RINDOLF_DEST): $(MY_NAME_IS_RINDOLF_SRC)
	$(IMAGE_CONVERT) -resize '200' $< $@

$(RPG_DICE_SET_DEST): $(RPG_DICE_SET_SRC)
	$(IMAGE_CONVERT) -resize '300x' $< $@

non_latemp_targets: $(Evilphish_flipped_dest)
non_latemp_targets: $(RPG_DICE_SET_DEST)

$(Shlomif_cutethulhu_DEST): $(Shlomif_cutethulhu_SRC)
	$(IMAGE_CONVERT) -resize '170x' $< $@

non_latemp_targets: $(Shlomif_cutethulhu_DEST)

$(Shlomif_mlpfim_shirt_DEST): $(Shlomif_mlpfim_shirt_SRC)
	$(IMAGE_CONVERT) -rotate 90 -resize '400x' $< $@

non_latemp_targets: $(Shlomif_mlpfim_shirt_DEST)

$(Shlomif_sglau_shirt_field_DEST): $(Shlomif_sglau_shirt_field_SRC)
	$(IMAGE_CONVERT) -rotate 90 -resize '400x' $< $@

non_latemp_targets: $(Shlomif_sglau_shirt_field_DEST)

Linux1_webp_DEST := $(POST_DEST)/art/images/linux1.webp
$(Linux1_webp_DEST): $(SRC_SRC_DIR)/art/images/linux1.gif
	$(IMAGE_CONVERT) $< -define webp:lossless=true $@

image_files: $(GRIMMIE_IMG_DEST)
image_files: $(Linux1_webp_DEST)

$(Evilphish_flipped_dest): $(Evilphish_flipped_src)
	$(IMAGE_CONVERT) -flop $< $@

$(BK2HP_NEW_PNG): lib/images/back_to_my_homepage_from_inkscape.png
	$(IMAGE_CONVERT) -matte -bordercolor none -border 5 $< $@
	$(OPTIPNG) $@

ART_SLOGANS_DOCS := \
	chromaticd/kiss-me-my-blog-post-got-chormaticd \
	CPP-supports-OOP/CPP-supports-OOP-as-much-as \
	dont-believe-in-fairies/dont-believe-in-fairies \
	give-me-ascii/give-me-ASCII-or-give-me-death \
	lottery-all-you-need-is-a-dollar/lottery-all-you-need-is-a-dollar \
	what-do-you-mean-by-wdym/what-do-you-mean-by-wdym \

ART_SLOGANS_PATHS := $(addprefix $(POST_DEST)/art/slogans/,$(ART_SLOGANS_DOCS))
ART_SLOGANS_PNGS := $(addsuffix .png,$(ART_SLOGANS_PATHS))
ART_SLOGANS_THUMBS := $(addsuffix .thumb.png,$(ART_SLOGANS_PATHS))

art_slogans_targets: $(ART_SLOGANS_THUMBS) $(BUFFY_A_FEW_GOOD_SLAYERS__SMALL_LOGO_PNG) $(THE_ENEMY_SMALL_LOGO_PNG) $(HHFG_SMALL_BANNER_AD_PNG) $(PRINTER_ICON_PNG) $(TWITTER_ICON_20_PNG) $(BK2HP_NEW_PNG) $(POST_DEST_HTML_6_LOGO_PNG)

$(POST_DEST_HTML_6_LOGO_PNG): $(SRC_SRC_DIR)/humour/bits/HTML-6/HTML-6-logo.svg
	$(INKSCAPE_WRAPPER) --export-dpi=60 --export-area-page --export-type=png --export-filename="$@" "$<"
	$(OPTIPNG) $@

POST_DEST_WINDOWS_UPDATE_SNAIL_ICON := $(POST_DEST_HUMOUR)/bits/facts/images/windows-update-snail.png

image_files: $(POST_DEST_WINDOWS_UPDATE_SNAIL_ICON) $(POST_DEST_FIERY_Q_PNG)

$(POST_DEST_WINDOWS_UPDATE_SNAIL_ICON): $(SRC_SRC_DIR)/humour/bits/facts/images/snail.svg
	$(INKSCAPE_WRAPPER) --export-width=200 --export-type=png --export-filename="$@" $<
	$(OPTIPNG) $@

$(ART_SLOGANS_PNGS): %.png: %.svg
	$(INKSCAPE_WRAPPER) --export-type=png --export-filename=$@ $<
	$(OPTIPNG) $@

$(ART_SLOGANS_THUMBS): %.thumb.png: %.png
	$(IMAGE_CONVERT) -resize '200' $< $@
	$(OPTIPNG) $@

$(PRINTER_ICON_PNG): common/images/printer_icon.svg
	$(INKSCAPE_WRAPPER) --export-width=30 --export-type=png --export-filename="$@" $<
	$(OPTIPNG) $@

$(TWITTER_ICON_20_PNG): common/images/twitter-bird-light-bgs.svg
	$(INKSCAPE_WRAPPER) --export-width=30 --export-type=png --export-filename="$@" $<
	$(OPTIPNG) $@

$(HHFG_SMALL_BANNER_AD_PNG): $(SRC_SRC_DIR)/humour/human-hacking/images/hhfg-ad-468x60.svg.png
	$(IMAGE_CONVERT) -resize '50%' $< $@
	$(OPTIPNG) $@

SRC_jpgs__BASE := $(filter $(POST_DEST)/humour/Selina-Mandrake/%.jpg,$(SRC_IMAGES_DEST))
SRC_jpgs__BASE += $(filter $(POST_DEST)/humour/bits/%.jpg,$(SRC_IMAGES_DEST))
SRC_jpgs__BASE += $(filter $(POST_DEST)/humour/images/strong-woman-meme-summer-glau/%.jpg,$(SRC_IMAGES_DEST))
SRC_jpgs__BASE += $(filter $(POST_DEST)/images/vague.jpg,$(SRC_IMAGES_DEST))
SRC_jpgs__BASE += $(filter $(POST_DEST)/meta/FAQ/images/%.jpg,$(SRC_IMAGES_DEST))
SRC_jpgs__BASE += $(POST_DEST)/images/TN-Rivendell.jpg
SRC_jpgs__BASE += $(POST_DEST)/images/shlomif-sglau-nsa-shirt-250w.jpg
SRC_jpgs__webps := $(SRC_jpgs__BASE:%.jpg=%.webp)
$(SRC_jpgs__webps): %.webp: %.jpg
	$(call simple_gm)

SRC_rjpgs__webps := $(SRC_jpgs__BASE:%.jpg=%--reduced.webp)
$(SRC_rjpgs__webps): %--reduced.webp: %.jpg
	$(IMAGE_CONVERT) -resize '200' $< $@

SRC_pngs__BASE := $(filter $(POST_DEST)/humour/bits/%.png,$(SRC_IMAGES_DEST)) \
	$(POST_DEST_HTML_6_LOGO_PNG) \
	$(POST_DEST)/humour/images/14920899703_243677cbf4_o--cropped.png \
	$(POST_DEST)/humour/images/14920899703_243677cbf4_o--crop150w.png \
	$(POST_DEST)/humour/images/14920899703_243677cbf4_o--crop300w.png \
	$(POST_DEST)/images/shlomi-fish-in-a-red-ET-shirt--IMG_20201218_190912--200w.png \

SRC_pngs__webps := $(SRC_pngs__BASE:%.png=%.webp)
$(SRC_pngs__webps): %.webp: %.png
	$(call simple_gm)

# slower:
#$(SRC_pngs__webps): $(SRC_pngs__BASE)
#	$(PERL) bin/multi-gm.pl .png .webp $^

SRC_SVGS__BASE := $(filter %.svg,$(SRC_IMAGES_DEST))
SRC_SVGS__MIN := $(SRC_SVGS__BASE:%.svg=%.min.svg)
SRC_SVGS__svgz := $(SRC_SVGS__BASE:%.svg=%.svgz)

$(SRC_SVGS__MIN): %.min.svg: %.svg
	minify -q --svg-precision 5 -o $@ $<

$(SRC_SVGS__svgz): %.svgz: %.min.svg
	gzip --best -n < $< > $@


BIZCARD_SVG_INPUT_BN := bizcard.svg
BIZCARD_SVG_OUTPUT_BN := embedded-png-bizcard.svg
BIZCARD_SVG_DIR := $(SRC_SRC_DIR)/me/images
BIZCARD_SVG_OUTPUT_PATH := $(BIZCARD_SVG_DIR)/$(BIZCARD_SVG_OUTPUT_BN)

$(BIZCARD_SVG_OUTPUT_PATH): $(BIZCARD_SVG_DIR)/$(BIZCARD_SVG_INPUT_BN)
	( set -e -x ; d="`pwd`" ; md="$${d}/$(BIZCARD_SVG_DIR)" ; HOME="$${md}" python3 /usr/share/inkscape/extensions/image_embed.py "$<" > "$@" )

image_files: $(BIZCARD_SVG_OUTPUT_PATH)
