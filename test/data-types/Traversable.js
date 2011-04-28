/*
  Generic test of every prototype that has Traversable as it's super prototype.

  @author Mads Hartmann Jensen (mads379@gmail.com)
*/

$(document).ready(function(){

  var equalsKVObj = function(kv1, kv2) {
    if (kv1.key == kv2.key && kv1.value == kv2.value ) {
      return true;
    } else {
      return false;
    }
  };

  /* Function that checks if two arrays are equal.
     TODO: Move to some place where other tests can use it as well
  */
  var equals = function(xs,ys) {
    if (xs.length != ys.length) {
      return false;
    }

    var i;
    for ( i = 0 ; i < xs.length ; i++) {
      if (typeof xs[i] == "number" && xs[i] != ys[i]) {
          return false;
      }
      if (typeof xs[i] == "object" && !equalsKVObj(xs[i], ys[i])) {
        return false;
      }
    }
    return true;
  };

  var generic_traversable_test = function(name, Constructor, support){

    module("Traversable of " + name);

    test("map", function() {

      var stdMapFunction = function(elem){ return elem*2; };
      var mapFunction = support.mapFunction || stdMapFunction;

      var list = new Constructor(support.map.input).map( mapFunction ).asArray();

      console.log(name);
      console.log(list);

      ok(equals(list, support.map.expected));
    });

    test("flatMap", function() {
      var list = new Constructor(support.flatMap.input).flatMap( function(elem){
        return new Constructor(support.flatMap.input);
      }).asArray();

      ok(equals(list, support.flatMap.expected));
    });

    test("filter", function() {

      var stdFilterFunction = function(elem){ return elem >= 2; };
      var filterFunction = support.filterFunction || stdFilterFunction;

      var list = new Constructor(support.filter.input).filter(filterFunction).asArray();

      ok(equals(list, support.filter.expected));
    });

  };

  /* These objects are needed for the generic test to work - some of the data types have
     different expected output. I.e. a Set can't have duplicated items etc. */

  var normalSupport = {
    'map'    : { 'input' : [1,2,3], 'expected' : [2,4,6] },
    'flatMap': { 'input' : [1,2,3], 'expected' : [1,2,3,1,2,3,1,2,3] },
    'filter' : { 'input' : [1,2,3], 'expected' : [2,3] }
  };

  var setSupport = {
    'map'    : { 'input' : [1,2,3], 'expected' : [2,4,6] },
    'flatMap': { 'input' : [1,2,3], 'expected' : [1,2,3] },
    'filter' : { 'input' : [1,2,3], 'expected' : [2,3]   }
  };

  var mapInput = [{ key: 1, value: 1},
                  { key: 2, value: 2},
                  { key: 3, value: 3}];
  var mapSupport = {
    'map'     : { 'input'    : mapInput,
                  'expected' : [{ key: 1, value: 2},
                                { key: 2, value: 4},
                                { key: 3, value: 6}]},
    'flatMap' : { 'input'    : mapInput,
                  'expected' : mapInput},
    'filter'  : { 'input'    : mapInput,
                  'expected' : [{key: 2, value: 2 },
                                {key: 3, value: 3}]},
    // the functions passed to the map needs to take a kv object, not an integer
    'mapFunction' : function(kv) { return { key : kv.key, value : kv.value*2 }; },
    'filterFunction' : function(kv) { return kv.value >= 2; }
  };

  var someSupport = {
    'map'     : { 'input' : 10, 'expected' : [20]},
    'flatMap' : { 'input' : 10, 'expected' : [10]},
    'filter'  : { 'input' : 10, 'expected' : [10]}
  };

  var noneSupport = {
    'map'     : { 'input' : 10, 'expected' : []},
    'flatMap' : { 'input' : 10, 'expected' : []},
    'filter'  : { 'input' : 10, 'expected' : []}
  };

  /* go! */

  generic_traversable_test("List",        mugs.List,             normalSupport);
  generic_traversable_test("TreeSet",     mugs.TreeSet,          setSupport);
  generic_traversable_test("LLRBSet",     mugs.LLRBSet,          setSupport);
  generic_traversable_test("Stack",       mugs.Stack,            normalSupport);
  generic_traversable_test("Queue",       mugs.Queue,            normalSupport);
  generic_traversable_test("TreeMap",     mugs.TreeMap,          mapSupport);
  generic_traversable_test("LLRBTreeMap", mugs.LLRBMap,          mapSupport);
  generic_traversable_test("Some",        mugs.Some,             someSupport);
  generic_traversable_test("None",        mugs.None,             noneSupport);
  generic_traversable_test("RAL",         mugs.RandomAccessList, normalSupport);


});
