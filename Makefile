
T2_DOCS = $(shell cd t2 && find . -name '*.wml')

T2_DEST = /var/www/html/shlomi/t2-homepage

WML_FLAGS += --passoption=2,-X

T2_WML_FLAGS = $(WML_FLAGS) -DROOT~. -DVIPE_URL="/shlomi/vipe-homepage"

all: $(T2_DOCS)

$(T2_DOCS) :: $(T2_DEST)/% : t2/%.wml
	cd t2 && wml -DFILENAME=$(notdir $@) $(patsubst t2/%,%,$<) > $@
