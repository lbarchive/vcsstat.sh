vcsstat.sh
==========

A Bash script to list numbers of additions, deletions, and commits of repositories.

Example
-------

Listing the repos with diff statistics within time range:

    $ vcsstat.sh -Z -C '' -7 '1 week ago'
    [ Hg] b.py                           +   965 / -   438 / C    18
    [Git] dotfiles                       +   160 / -    10 / C     3
    [ Hg] g                              +     7 / -     3 / C     2
    [Git] jquery-textfill                +    23 / -    14 / C     4
    [Git] newyear-resolution             +  1430 / -    83 / C     7
    [Git] pipes.sh                       +    33 / -    15 / C     4
    [ Hg] urtimer                        +    41 / -    10 / C     2
    [ Hg] vcsstat.sh                     +   131 / -    42 / C     4
    [ Hg] yjl.im                         +     4 / -     4 / C     1
    ----------------------------------------------------------------
    TOTAL                                +  2794 / -   619 / C    45

Showing commits made in 2012 in Commit Calendar mode:

    $ vcsstat.sh -c -U $USER 2012 2012 2012
    2012Feb Mar Apr  May Jun Jul  Aug Sep  Oct Nov Dec
    ...+........-..+...+-...........................+-...
    ......+........*@..-.....-.....................*+....
    ..-......+.-.....+-.-.*........................---...
    .......-.+......*-.......-...................@--...-.
    ..........---...-...-........................-.......
    ...........-...-..*..................................
    .......-...--..-.....-..........................*-...

Usage
-----

    vcsstat.sh [options] [''|AUTHOR_NAME [''|HG_DATESPEC [''|GIT_SINCE [''|GIT_UNTIL]]]]

Every argument is basically optional, however you need to use '' to indicate
that you are not specifying it.

### Options

    -c:       Commit calendar mode
    -C:       Do not color output
    -U:       Do not use Unicode (only for -c and implies -C)
    -Z:       Filter out repo with no changes

### `HG_DATESPEC` Examples

    "2011-08"
    "2011-01 to 2011-03" # Jan. to Mar. in 2011
    ">2011-05"           # Since May.
    "-3"                 # Last three days

See `man hg ` for `DATE FORMATS` section.

### `GIT_SINCE and GIT_UNTIL` Examples

    "2011-01-23"
    "yesterday"
    "2 weeks ago"

See..., uhm I have no idea where to look at. `man gitrevisions` for date specification, perhaps?

License
-------

    Copyright (C) 2011, 2013 by Yu-Jie Lin
