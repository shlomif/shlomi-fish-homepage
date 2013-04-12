POV_BASE = stone-heart.png

PNG = $(POV_BASE).png

all: $(PNG)

$(PNG): $(POV_BASE).pov
	povray $<

view: all
	gwenview $(PNG)
