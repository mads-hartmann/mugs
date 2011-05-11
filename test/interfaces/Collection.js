/*
  Test the checks that a specific implementation conforms to the Collection interfaces
*/

$(document).ready(function() {

    var implements_Collection = function(name, Constructor, support) {

        module(name + "(Collection)");

        test("isEmpty", function() {
            var col = new Constructor(support.isEmpty.input);
            ok(support.isEmpty.expected == col.isEmpty());
            ok( new Constructor([]).isEmpty() === true);
        });

        test("size", function() {
            var col = new Constructor(support.size.input);
            ok(support.size.expected == col.size());
            ok(new Constructor([]).size() === 0);
        });

        test("contains", function() {
            var col = new Constructor(support.contains.input);
            var item = support.contains.input[0];
            if (item.value !== undefined) {
                item = item.value;
            }

            ok(col.contains(item) === true);
            ok(col.contains(99) === false);
        });

        test("map", function() {
            var stdMapFunction = function(elem){ return elem*2; };
            var mapFunction = support.mapFunction || stdMapFunction;

            var list = new Constructor(support.map.input).map( mapFunction ).asArray();

            ok(equalsArr(list, support.map.expected));
        });

        test("flatMap", function() {
            var list = new Constructor(support.flatMap.input).flatMap( function(elem){
                return new Constructor(support.flatMap.input);
            }).asArray();

            ok(equalsArr(list, support.flatMap.expected));
        });

        test("filter", function() {
            var stdFilterFunction = function(elem){ return elem >= 2; };
            var filterFunction = support.filterFunction || stdFilterFunction;

            var list = new Constructor(support.filter.input).filter(filterFunction).asArray();

            ok(equalsArr(list, support.filter.expected));
        });

        test("forEach", function() {
            var positive = false;
            var collection = new Constructor(support.size.input);
            collection.forEach( function(item){ positive = true; });
            ok(positive);
        });
    };
    
    /* 
        These objects are needed for the generic test to work - some of the data types have
        different expected output. I.e. a Set can't have duplicated items etc. 
    */
    
    var normalSupport = {
        'isEmpty'  : { 'input' : [1,2,3], 'expected' : false },
        'size'     : { 'input' : [1,2,3], 'expected' : 3 },
        'contains' : { 'input' : [1,2,3]},
        'map'      : { 'input' : [1,2,3], 'expected' : [2,4,6] },
        'flatMap'  : { 'input' : [1,2,3], 'expected' : [1,2,3,1,2,3,1,2,3] },
        'filter'   : { 'input' : [1,2,3], 'expected' : [2,3] }
    };

    var setSupport = {
        'isEmpty'  : { 'input' : [1,2,3], 'expected' : false  } ,
        'size'     : { 'input' : [1,2,3], 'expected' : 3 },
        'contains' : { 'input' : [1,2,3]},
        'map'      : { 'input' : [1,2,3], 'expected' : [2,4,6] },
        'flatMap'  : { 'input' : [1,2,3], 'expected' : [1,2,3] },
        'filter'   : { 'input' : [1,2,3], 'expected' : [2,3]   }
    };

    var mapInput = [{ key: 1, value: 1},
                    { key: 2, value: 2},
                    { key: 3, value: 3}];

    var mapSupport = {
        'isEmpty'  : { 'input'  : mapInput, 'expected' : false },
        'size'     : { 'input'  : mapInput, 'expected' : 3 },
        'contains' : { 'input'  : mapInput},
        'flatMap'  : { 'input'    : mapInput, 'expected' : mapInput},
        'filter'   : { 'input'    : mapInput, 'expected' : [{key: 2, value: 2 },
                                                            {key: 3, value: 3}]},
        'map'      : { 'input'    : mapInput, 'expected' : [{ key: 1, value: 2},
                                                            { key: 2, value: 4},
                                                            { key: 3, value: 6}]},
        // the functions passed to the map needs to take a kv object, not an integer
        'mapFunction' : function(kv) { return { key : kv.key, value : kv.value*2 }; },
        'filterFunction' : function(kv) { return kv.value >= 2; }
    };

    /*
        Now run the tests for every prototype that implements Collection (i.e. all of them)
    */
    
    implements_Collection("List",        mugs.List,             normalSupport);
    implements_Collection("TreeSet",     mugs.TreeSet,          setSupport);
    implements_Collection("LLRBSet",     mugs.LLRBSet,          setSupport);
    implements_Collection("Stack",       mugs.Stack,            normalSupport);
    implements_Collection("Queue",       mugs.Queue,            normalSupport);
    implements_Collection("TreeMap",     mugs.TreeMap,          mapSupport);
    implements_Collection("LLRBTreeMap", mugs.LLRBMap,          mapSupport);
    implements_Collection("RAL",         mugs.RandomAccessList, normalSupport);
});
  
