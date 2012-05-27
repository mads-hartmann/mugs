Mugs
================

Mugs is a immutable collections library for JavaScript written in Coffeescript. It is the product of the Bachelors project by Mads Hartmann Jensen. 

Building it
-----------

You need to have [coffeescript](http://coffeescript.org) and [cake](http://coffeescript.org/#cake) installed

Simple run

    cake build 

Now you should be able to run the files in `examples/client-side/`.

Running the tests
-----------------

### Qunit

First you can you compile the coffeescript into javascript. Simply run 'cake build'. Now point your favorite browser at test/index.html and what the result of running all of the qunit tests

### JSCoverage 

As above you need to run 'cake build' followed by 'cake jscoverage'. Now point your browser at http://127.0.0.1:8080/jscoverage.html?test/index.html to see the coverage of running the tests. 