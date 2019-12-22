**Note:** there is a similar essay on [software disenchantment](https://tonsky.me/blog/disenchantment/)
and probably many other similar ones.

* Essay: reflections on how software quality has improved/worsened.
    - Follow-up on http://www.shlomifish.org/philosophy/computers/high-quality-software/rev2/
    - Follow-up on https://en.wikibooks.org/wiki/Optimizing_Code_for_Speed
    - Follow-up on http://perl-begin.org/tutorials/bad-elements/
    - Follow-up on http://www.shlomifish.org/lecture/C-and-CPP/bad-elements/
    - Follow-up on https://github.com/shlomif/Freenode-programming-channel-FAQ/blob/master/FAQ.mdwn#what-are-some-best-practices-in-programming-that-i-should-adopt
    - Freecell Solver speedups ( https://github.com/shlomif/fc-solve/tree/master/fc-solve/benchmarks ), new features ( http://fc-solve.shlomifish.org/features.html ), tests suite, CI, etc.  - cost of code complexity and readability
    - Learned about [CI](https://en.wikipedia.org/wiki/Continuous_integration) from https://perlhacks.com/2012/03/you-must-hate-version-control-systems/
    - Since the essays were written, some apps improved while others got worse.
    - Electron-based apps:
        - http://www.shlomifish.org/humour/bits/Atom-Text-Editor-edits-2_000_001-bytes/
        - https://www.reddit.com/r/programming/comments/73vua5/benchmarks_showing_electron_apps_are_super_slow/
    - Software becoming slower and more resource hungry:
        - https://medium.com/@okaleniuk/premature-optimization-is-the-root-of-all-evil-is-the-root-of-evil-a8ab8056c6b
        - https://twitter.com/TheoVanGrind/status/888850519564984322
        - https://twitter.com/xbs/status/626781529054834688
    - Windows Update - slow:
        - http://www.shlomifish.org/humour/bits/facts/Windows-Update/
        - Reportedly still breaks the system sometimes
        - Gets invoked at inconvenient times
            - Like at computer shutdown
    - Red Hat's dnf
        - kinda slow
        - hopefully [will improve](https://rpm-software-management.github.io/announcement/2018/03/22/dnf-3-announcement/)
    - Mostly Positive: [VLC](https://www.videolan.org/vlc/)
        - Easy to use interface
        - Popular among many Windows and macOS users.
    - Mostly Positive: [Emscripten](https://en.wikipedia.org/wiki/Emscripten) / asm.js / WebAssembly
    - Mostly Positive: [pypy](https://en.wikipedia.org/wiki/PyPy)
        - Fast
    - KDE/Plasma's update from 3 to 4 was poorly done, and so was 4→5.
        - Seems like most people except for the KDE core developers do not appreciate the emphasis on the so-called ["Activities"](https://askubuntu.com/questions/253990/what-is-a-activity-in-kde-and-what-can-i-do-with-it) instead of on virtual workspaces.
        - https://bugs.kde.org/show_bug.cgi?id=343246
        - http://www.trinitydesktop.org/
    - Mostly Positive: [cmake](https://en.wikipedia.org/wiki/CMake)
        - Not perfect but less errorprone and faster than GNU Autotools
        - http://www.shlomifish.org/open-source/anti/autohell/
        - https://en.wikipedia.org/wiki/Meson_(software)
    - Reflections on "Simple" in the context of software:
        - https://shlomif-tech.livejournal.com/64318.html
        - Simple may imply lacking features or being hard to use.

## Comment I wrote

On https://medium.com/@okaleniuk/premature-optimization-is-the-root-of-all-evil-is-the-root-of-evil-a8ab8056c6b :

Hi! Good article. I should note that based on what I wrote [here](https://en.wikibooks.org/wiki/Optimizing_Code_for_Speed/Factor_Optimizations#Are_%22Small%22_Optimizations_Desirable?) - Prof. Knuth may have been wrong because many small optimisations eventually can add to a significant improvement. Perhaps sometimes an optimisation is not worth it because the program is already fast enough, but I feel that we have accumulated too much junk bloatware recently (see [my notes](https://github.com/shlomif/shlomi-fish-homepage/blob/4d2c897b486f0c7cfc0b7fe29f3f49b61fb8054a/lib/notes/quality-software--followup-2018.md) ).

Regarding the "it's good there is more work for me", this is the [broken window fallacy](https://shlomif-tech.livejournal.com/741.html) - and it is also echoed in the ["how to become a hacker (not "cracker") howto"](http://www.catb.org/esr/faqs/hacker-howto.html). You likely have better things to do than to fix others' past failures.
