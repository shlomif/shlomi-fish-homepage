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

Linux1_webp_DEST := $(POST_DEST)/art/images/linux1.webp
$(Linux1_webp_DEST): $(SRC_SRC_DIR)/art/images/linux1.gif
	$(IMAGE_CONVERT) $< -define webp:lossless=true $@

all: $(GRIMMIE_IMG_DEST)
all: $(Linux1_webp_DEST)

$(Evilphish_flipped_dest): $(Evilphish_flipped_src)
	$(IMAGE_CONVERT) -flop $< $@

$(BK2HP_NEW_PNG): lib/images/back_to_my_homepage_from_inkscape.png
	$(IMAGE_CONVERT) -matte -bordercolor none -border 5 $< $@
	$(OPTIPNG) $@

art_slogans_targets: $(ART_SLOGANS_THUMBS) $(BUFFY_A_FEW_GOOD_SLAYERS__SMALL_LOGO_PNG) $(THE_ENEMY_SMALL_LOGO_PNG) $(HHFG_SMALL_BANNER_AD_PNG) $(PRINTER_ICON_PNG) $(TWITTER_ICON_20_PNG) $(BK2HP_NEW_PNG) $(POST_DEST_HTML_6_LOGO_PNG)

$(POST_DEST_HTML_6_LOGO_PNG): $(SRC_SRC_DIR)/humour/bits/HTML-6/HTML-6-logo.svg
	$(INKSCAPE_WRAPPER) --export-dpi=60 --export-area-page --export-type=png --export-filename="$@" "$<"
	$(OPTIPNG) $@

POST_DEST_WINDOWS_UPDATE_SNAIL_ICON := $(POST_DEST_HUMOUR)/bits/facts/images/windows-update-snail.png

all: $(POST_DEST_WINDOWS_UPDATE_SNAIL_ICON) $(POST_DEST_FIERY_Q_PNG)

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
SRC_jpgs__BASE += $(POST_DEST)/images/TN-Rivendell.jpg
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
	minify --svg-precision 5 -o $@ $<

$(SRC_SVGS__svgz): %.svgz: %.min.svg
	gzip --best -n < $< > $@
