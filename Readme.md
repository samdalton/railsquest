Railsquest - Local git publication and collaboration
====================================================

Via the [best reddit comment ever written](http://www.reddit.com/r/programming/comments/9txsd/git_bonjour_railsquest_version_22_released/c0efrxz):

> The logo is the fucking business. The mustache just bring[s] it to a whole
> other level.

Railsquest is local git quest hosting with a sexy web interface and Bonjour discovery. It's like a bunch of adhoc, local, network-aware githubs!

Unlike Gitjour, the quests you're serving are not your working git quests, they're served from `~/.railsquest/quests`. You can push to your railsquest quests from your working copies just like you do with github.

Follow [@railsquest](http://twitter.com/railsquest) on twitter for all release updates.

![Screenshot of local view of Railsquest 2.1.3](http://cloud.github.com/downloads/toolmantim/railsquest/screenshot.png)

Installation and usage
----------------------

You'll need at least [git version 1.6](http://git-scm.com/). Run `git --version` if you're unsure.

Install it from [gemcutter](http://gemcutter.org/) via gems:

    gem install railsquest

(you might need to do a `gem sources -a http://gemcutter.org` beforehand!)

Start it up:

    railsquest

Go into an existing project and add it to railsquest:

    cd ~/code/myproj
    railsquest add

Publish your codez:

    git push quest master

Fire up [http://localhost:9331/](http://localhost:9331/) to check it out.

If somebody starts sharing a Railsquest quest with the same name on the
network it'll automatically show up in the network thanks to the wonder that is Bonjour.

For a list of all the commands:

    railsquest help

Optional configuration: you can override the hostname by setting a global git config option like so:

    git config --global railsquest.hostname foobar

If you set this setting, then railsquest will assume that you know precisely what you're doing, it will not append .local, it will not check this hostname is valid, or do anything to it.  If you set this, then you're on your own.

Linux support
-------------

To install the dnssd gem on Linux you'll need [avahi](http://avahi.org/). For Ubunutu peeps this means:

    sudo aptitude update

    sudo aptitude install g++ ruby-dev \
     libavahi-compat-libdnssd-dev avahi-discover avahi-utils

and you'll need to set the domain-name:

    sudo sed -i \
     -e 's/#domain-name=local/domain-name=local/' \
     /etc/avahi/avahi-daemon.conf

    sudo service avahi-daemon restart

You can debug whether or not Avahi can see Railsquest and git-daemon Bonjour statuses using the command 'avahi-browse'.  This command can be found in the package 'avahi-utils'.

The following command will show you all of the Bonjour services running on your local network:

    avahi-browse --all

If you kill railsquest with kill -9 it doesn't get a chance to unregister the Bonjour services, and when it is restarted it will die with DNSSD::AlreadyRegisteredError.  Although not ideal, you can work around this my restarting avahi-daemon first.

Note: You might have to restart the avahi-daemon sometimes if you are having problems seeing other railsquests.

Official quest and support
-------------------------------

The official repo and support issues/tickets live at [github.com/toolmantim/railsquest](http://github.com/toolmantim/railsquest).

Feature and support discussions live at [groups.google.com/group/railsquest](http://groups.google.com/group/railsquest).

Developing
----------

    bundle install
    rake -T

Contributors
------------

* [Carla Hackett](http://carlahackettdesign.com/) (logo)
* [Nathan de Vries](http://github.com/atnan)
* [Lachlan Hardy](http://github.com/lachlanhardy)
* [Josh Bassett](http://github.com/nullobject)
* [Myles Byrne](http://github.com/quackingduck)
* [Ben Hoskings](http://github.com/benhoskings)
* [Brett Goulder](http://github.com/brettgo1)
* [Tony Issakov](https://github.com/tissak)
* [Mark Bennett](http://github.com/MarkBennett)
* [Travis Swicegood](http://github.com/tswicegood)
* [Nate Haas](http://github.com/natehaas)
* [James Sadler](http://github.com/freshtonic)
* [Jason King](http://github.com/JasonKing)
* [Michael Pope](http://github.com/map7)

License
-------

All directories and files are MIT Licensed.

Warning to all those who still believe secrecy will save their revenue stream
-----------------------------------------------------------------------------
Bananas were meant to be shared. There are no secret quests.
