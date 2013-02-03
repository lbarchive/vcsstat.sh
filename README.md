vcsstat.sh
==========

A Bash script to list additions and deletions of repositories.

Example
-------

Listing the repos with diff statistics within time range:

    $ vcsstat.sh -Z -C '' -7 '1 week ago'
    [ Hg] b.sh                           +   420 / -     0
    [ Hg] g                              +    33 / -     0
    [Git] jquery-textfill                +   458 / -     0
    [ Hg] yjl.im                         +   151 / -     0
    TOTAL                                +  1062 / -     0

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
