SRC_jpgs__BASE := $(filter $(POST_DEST)/humour/Selina-Mandrake/%.jpg,$(SRC_IMAGES_DEST))
SRC_jpgs__BASE += $(filter $(POST_DEST)/humour/bits/%.jpg,$(SRC_IMAGES_DEST))
SRC_jpgs__BASE += $(filter $(POST_DEST)/humour/images/strong-woman-meme-summer-glau/%.jpg,$(SRC_IMAGES_DEST))
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
