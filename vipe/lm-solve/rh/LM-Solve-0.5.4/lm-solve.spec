Name: lm-solve
Version: 0.5.4
Release: 1
Group: Amusement/Games
Source: http://vipe.technion.ac.il/~shlomif/lm-solve/LM-Solve-%{version}.tar.gz
Buildroot: %{_tmppath}/%{name}-buildroot
Requires: perl
URL: http://vipe.technion.ac.il/~shlomif/lm-solve/
Prefix: %{_prefix}
License: Public Domain
BuildArch: noarch
Summary: Perl-based solver for various types of logic mazes

%description
LM-Solve is a solver for various types of Logic Mazes as features on the 
Logic Mazes site (http://www.logicmazes.com/). Currently it supports Alice 
Mazes, Number Mazes, Plank Puzzles, Theseus and the Minotaur Mazes and
three type of Tilt Mazes (single goal, multiple goals and red-blue tilt 
puzzles)

%prep
%setup -q -n LM-Solve-%{version}


%build
%{__perl} Makefile.PL PREFIX=%{prefix} < /dev/null
make OPTIMIZE="$RPM_OPT_FLAGS" PREFIX=%{prefix}
make test

%install
rm -rf $RPM_BUILD_ROOT
%makeinstall PREFIX=$RPM_BUILD_ROOT%{prefix} INSTALLMAN1DIR=$RPM_BUILD_ROOT%{_mandir}/man1

%clean
rm -fr $RPM_BUILD_ROOT

%files
%defattr (-,root,root)
%doc README TODO MANIFEST COPYING INSTALL
%{_bindir}/*
%{_mandir}/*/*
%{_libdir}/perl5/site_perl/*/Shlomif

%changelog
* Sat Jul 27 2002 Shlomi Fish <shlomif@vipe.technion.ac.il> 0.5.3-1
- First working version of the SPEC.

