vcsstat.sh
==========

A Bash script to list numbers of additions, deletions, and commits of repositories.

[TOC]

Installation
------------

By default, to install to `/usr/local`, run:

    $ make install

Or to `/usr`:
    
    $ make install PREFIX=/usr

Or to your home:

    $ make install PREFIX=$HOME

To uninstall, use `uninstall` target with `PREFIX` if supplied during installation.

Usage
-----

    vcsstat.sh [options] [''|AUTHOR_NAME [''|HG_DATESPEC [''|GIT_SINCE [''|GIT_UNTIL]]]]

Every argument is basically optional, however you need to use '' to indicate
that you are not specifying it.

### Options

    -c:       Commit calendar mode
    -p:       Punchcard mode
    -x:       Output additions/deletions/commits in CSV format
    -C:       Do not color output
    -U:       Do not use Unicode (only for -c and implies -C)
    -Z:       Filter out repo with no changes
    -m:       Week starts with Mondays

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

Examples
--------

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

### Punchcard mode

[![punchcard](https://lh3.googleusercontent.com/-bHKFAtztM3Q/UbUGnPNBvII/AAAAAAAAE5s/hvpM2mxapW8/s640/vcsstat.sh%2520punchcard%2520mode%25202013-06-10--06%253A46%253A55.png)](https://picasaweb.google.com/lh/photo/A99rbb4Jq29ML5zE7timOgAR95DKuQ-7LD03-K9DA7Q?feat=directlink)

### CSV output

    vcsstat.sh -x $USER '>2011' 2011

    Type,Repository,Additions,Deletions,Commits
    Git,KLTT,361,108,12
    Git,agileshare,1988,19,9
    Hg,yjl,4342,21356,153
    Hg,yjlwiki,2885,2503,16
    TOTAL,,63650,49760,959

### Fun with [gitfiti][]

Graffiti in Git:

![graffiti](https://lh5.googleusercontent.com/-LBxEscGbTKM/UZuNioCbXSI/AAAAAAAAE0I/6vumCkRuOv4/s800/gitfiti%2520and%2520vcsstat.sh%25202013-05-21--23%253A00%253A22.png)

[gitfiti]: https://github.com/gelstudios/gitfiti

License
-------

    vcsstat.sh is licensed under the MIT License
    Copyright (C) 2011, 2013, 2014 by Yu-Jie Lin
