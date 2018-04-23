# gmakepod

A tiny podcast client written in GNU Make with sprinkles of Ruby.

## Why?

Why not?

107 lines of Make + 39 lines of Ruby according to cloc. You'd think w/
such a size it cannot make practically anything except for downloading
a bunch of files, but it can do so much more, swiftly & w/ style! hehe

* download in parallel;
* filter by subs name, enclosure type or url;
* auto-convert odd ogg/m4a/whatever to mp3;
* no pointless re-downloading of enclosures unless you command
  otherwise;
* sort in reverse, so you may fetch the 1st 2 episodes, instead of the
  last 2, for example;
* 'catch up' w/ feeds w/o downloading anything.

## Install

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

An optional `convert-to` param tells gmakepod that it'll need to
convert each enclosure (from that feed only) to `mp3`. The dot is
important.

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

For parallel downloads, pass `j=N` param. Type also `gmakepod help`.

## How does it work?

1. parse .ini to extract feeds names & urls
2. fetch & parse each feed to extract enclosures urls
3. generate a proper output file name for each url
4. check if we have already downloaded a url in the past, filter out;
   we don't need any db for that, for Ruby has a nifty `PStore` lib
   that nobody ever uses
5. generate a makefile, where we list all the rules for all the
   enclosures
6. run the makefile

xxx->mp3 conversions require ffmpeg (tested /w 3.3.6) & gawk.

![kumamon](https://ultraimg.com/images/2018/04/23/MTW8.jpg)

## License

MIT.
