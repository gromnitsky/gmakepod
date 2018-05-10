# gmakepod

A tiny podcast client written in GNU Make with sprinkles of Ruby.

## Why?

Why not? Besides 'because we can', this are the features you get when
using Make for something it wasn't intended for:

* download in parallel;
* filter by subs name, enclosure type or url;
* auto-convert odd ogg/m4a/whatever to mp3;
* no pointless re-downloading of enclosures unless you command
  otherwise;
* sort in reverse, so you may fetch the 1st 2 episodes, instead of the
  last 2, for example;
* 'catch up' w/ feeds w/o downloading anything.

Despite the number of src files, the client itself is rather small:

~~~
$ f='*rb *mk gmakepod'; join -j2 <(wc -l $f) <(du -bhc $f) | column -t -NFILE,LINES,SIZE
FILE                  LINES  SIZE
enclosures-print.rb   14     395
ini-parse.rb          6      174
u.rb                  19     543
enclosures-reject.mk  5      212
feed-parse.mk         24     830
generate.mk           48     1.1K
u.mk                  12     610
gmakepod              57     1.3K
total                 185    5.0K
~~~

## Install

Requires GNU Make 4+, Ruby 2.4+, curl.

~~~
$ git clone --recurse-submodules https://github.com/gromnitsky/gmakepod.git
$ cd gmakepod
$ bundle
~~~

Then create a symlink to `gmakepod` somewhere in PATH.

## Setup

Chose an 'umbrella' dir for your podcasts, e.g., `~/podcasts`; create
a file named `podcasts.ini` in that dir:

~~~
[BBC In Our Time]
url = http://downloads.bbc.co.uk/podcasts/radio4/iot/rss.xml

[Dave Winer]
url = http://scripting.com/rss.xml
convert-to = .mp3
~~~

An optional `convert-to` prop tells gmakepod that it'll need to
convert each enclosure (from that feed only) to `mp3` (the dot is
important). Other valid props here are `e`, `reverse`, `filter.type` &
`filter.url`. Type `gmakepod help` to read what they mean.

Now, cd to `~/podcasts` & type `gmakepod`. It should download the last
2 enclosures tops from each feed.

~~~
$ tree --noreport media
media/
├── BBC_In_Our_Time
│   ├── p02q5q4c.mp3
│   └── p02q5phk.mp3
└── Dave_Winer
    └── denverPostAndBerkeleyside.mp3
~~~

If you run `gmakepod` again it says '`make[1]: *** No targets.
Stop.`' because it refuses to process already processed enclosures.

For parallel downloads, pass `j=N` param.

## How does it work?

gmakepod target  | desc
---------------- | -------------------------------------------------------------
.feeds           | parse .ini to extract feeds names & urls
.enclosures      | fetch & parse each feed to extract enclosures urls
.files           | generate a proper output file name for each url
.files.new       | check if we have already downloaded a url in the past, filter out
.download.mk     | generate a makefile, where we list all the rules for all the enclosures
run              | run the makefile

xxx->mp3 conversions require ffmpeg (tested /w 3.3.6) & gawk.

![kumamon](https://ultraimg.com/images/2018/04/23/MTW8.jpg)

## Bugs

* tested on Fedora 27 only

## License

MIT.
