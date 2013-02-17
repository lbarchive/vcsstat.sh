vcsstat.sh
==========

A Bash script to list numbers of additions, deletions, and commits of repositories.

[TOC]

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

Example
-------

### Listing

    vcsstat.sh -Z $USER '>2011' 2011

![output](https://lh4.googleusercontent.com/-2xZlGFL7Rls/UQ6UJvC3gqI/AAAAAAAAEaY/RCDjyt5tySY/s800/vcsstat.sh.png)

### Calendar mode

    vcsstat.sh -c $USER '>2011' 2011

![calendar with color](https://lh6.googleusercontent.com/-pmy5cph0Zw8/UQ6UIjEduyI/AAAAAAAAEaQ/hKDTOZWAuj8/s800/vcsstat.sh%2520-%2520commit%2520calendar.png)

### Calendar mode without color

    vcsstat.sh -c -C $USER '>2011' 2011

![calendar without color](https://lh6.googleusercontent.com/-F5Mz3mkaJMk/UQ6UHb827EI/AAAAAAAAEaI/d10VfQSft-I/s800/vcsstat.sh%2520-%2520commit%2520calendar%2520-%2520no%2520color.png)

### Calendar mode without Unicode

    vcsstat.sh -c -U $USER '>2011' 2011

![calendar without Unicode](https://lh6.googleusercontent.com/-jlG8EZDWXok/UQ6UGUB2hnI/AAAAAAAAEaA/xAyiYmPZFQA/s800/vcsstat.sh%2520-%2520commit%2520calendar%2520-%2520no%2520Unicode.png)

License
-------

    vcsstat.sh is licensed under the MIT License
    Copyright (C) 2011, 2013 by Yu-Jie Lin
