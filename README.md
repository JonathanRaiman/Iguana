Iguana
======
*Linked Data Ventures Final Group Project*

See it running at [Iguana](http://iguanaetsy.herokuapp.com).

**collaborators**
*    Mitch Kates,
*    Jonathan Raiman

Installation
------------

0. ** install MongoDB **
	
	Recommended to do the following:
	
			brew install mongodb

			brew install memcache

	Then get cracking:

1.    Run

	    	bundle install

	from the directory

2.	You'll also need **rdf/raptor** to process RDF files:

	    	brew install raptor

	Now you are ready, you can type:

	    	ruby app.rb

	to get started.

3.	Navigate to ``localhost:4567`` and let the magic begin.

Tests
-----

for Capybara and route testing do:

    rspec specs/pageTest.rb

for everything else use Visa/Mastercard. Just kidding, do this:
	
	rake test

Issues
------
None to report at this data.
