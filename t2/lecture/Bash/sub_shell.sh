find . -name '*.c' |
(
	while read T ; do
		A=`echo $T | sed 's/\\.c\$//'`
		cp $T $A.bak
	done
)

# A is not set here.

