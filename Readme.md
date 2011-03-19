Railsquest - Propose and pursue quests for Ruby programming glory!
==================================================================

Pursue fame and glory by discovering and completing Quests, or offer a Quest to challenge your friends!
As you complete Quests, your trophy page will slowly fill up with your achievement badges.

Railsquest brings the magic of Bonjour auto-discovery to find Quests and other Challengers in your network.

Installation and usage
----------------------

Install it (from [gemcutter](http://gemcutter.org/)) via gems:

    gem install railsquest

(you might need to do a `gem sources -a http://gemcutter.org` beforehand!)

Start it up:

    railsquest

Then fire up [http://localhost:9876/](http://localhost:9876/) to begin your quest for the holy (g)rails!

Your name, as it will be seen by other people, is taken from your git global config setting.

You will see a list of all current adventurers, and a list of all available quests.
You can inspect the badges that have been won by other adventurers, and visit the quests to try them yourself.

How to create a quest
---------------------

Your quest is a web application running on your machine.
You can run it on any port you choose.
To make the quest available to other adventurers, add it to your railsquests:

railsquest add <port> "Name of your quest"

Specify the correct port number, and the name of your quest.

An adventurer will commence your quest by browsing from their Railsquest page.
Your quest application will receive a GET request with a "host" parameter.
The host is the computer hostname of the challenger (again from the git global config).
(TODO: We also need to make the adventurer's personal name available)

When you decide that an adventurer has completed your quest, you must notify
your local Railsquest server of their success by posting two parameters to

http://localhost:9876/submit

The post must contain these two parameters:

* The adventurer's "hostname"
* The "quest_name"

For example:

  require 'rest-client'

  RestClient.post 'http://localhost:9876/submit', :hostname => hostname, :quest_name => 'My Funky Quest'

Or using JQuery:

  $.post('http://localhost:9876/submit', {hostname: hostname, quest_name: 'My Funky Quest'});

Railsquest will then sign these facts into an achievement badge that will be displayed on the adventurer's trophy page!

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

Developing
----------

    bundle install
    rake -T

Contributors
------------

* [Sam Dalton](http://github.com/samdalton/)
* [Michael Dowse](http://michaeldowse.name/)
* [Clifford Heath](http://dataconstellation.com/)

With blithe cribbage from bananajour by...
* [Tim Lucas](http://www.toolmantim.com)
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
Bananas were meant to be shared. There are no secret bananas.
