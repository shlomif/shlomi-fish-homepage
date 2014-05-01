POV_BASE = stone-heart

PNG = $(POV_BASE).png

all: $(PNG)

$(PNG): $(POV_BASE).pov Makefile
	povray +ua +H200 +W300 $<

view: all
	gwenview $(PNG)
