newrb.rb
=====
Quick Ruby programming for experienced lazy developers on small utilities. It will enable your switch from other script languages to Ruby in short time without googling. If you believe that 20% of all Ruby grammar can support 80% of use as I do, then newrb.rb is your good choice. Personally I will use it to recall key syntax when I have stopped using Ruby for a while. newrb.rb will save 10 minutes each time we do language context switch.

Run Environment
---------------
Tested in Ruby 2.0 under Windows.

Ruby Installation
-----------------
Ruby is so famous that you can easily figure out how to download&install it via google. Otherwise just visit below link to save 10 seconds.
    http://rubyinstaller.org/downloads/

Module Management
-----------------
Ruby is powerful only because there are lots of useful modules. They are free for you, so you must learn to download&install modules.

gem should be available after Ruby installation otherwise check http://rubyforge.org/frs/?group_id=126&release_id=47112

    gem install <module>
    gem list


Install newrb.rb
----------------
Download newrb.rb from GitHub to your local disk. Edit newrb.rb with any text editor to overwrite below line with your email or other info as your author name.

    # Configuration Area Start for users of newrb.rb
    _author_ ='Yingjie.Liu@thomsonreuters.com'
    # Configuration Area End

Usage
-----

    Ruby newrb.rb -h

Use Cases
-------
generate test.rb without samples.

    Ruby newrb.rb test

list all existing samples

    Ruby newrb.rb -l

generate test.rb with sample 1 included only.

    Ruby newrb.rb test -s1

generate test.rb with sample 1 and 3 included as comment.

    Ruby newrb.rb test -s13 -c

By defaule, newrb.rb will submit statistical data to global database for new file generation. In such case, a global newrb.rb ID will be assigned to your test.rb. Your IP address, Author name and Sample Selection will be recorded. Those data will only be used to improve newrb.rb. Use -n to disable it.

Support
-------
mailto: jackandking@gmail.com

