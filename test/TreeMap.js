$(document).ready(function(){
  
  module("TreeMap");
  
  test("You can create a map with a single key-value pair", function() {
    var map = new TreeMap([
      {key: 1, value: "one"},
      {key: 4, value: "four"},
      {key: 3, value: "three"},
      {key: 2, value: "two"}
    ]);
    
    ok(map.get(1).get() == "one", "The element with key 1 has the value 'one'");
    ok(map.get(4).get() == "four", "The element with key 1 has the value 'four'");
    ok(map.get(3).get() == "three", "The element with key 1 has the value 'three'");
    ok(map.get(2).get() == "two", "The element with key 1 has the value 'two'");
    ok(map.get(10).isEmpty() === true, "Asking for a key that doesn't exist returns None");
  });
  
  test("You can insert a key-value pair into an existing map and get a new one",function() {
    var map = new TreeMap([ {key: 1, value: "one" }]).insert(2,"two");
    ok(map.get(2).get() == "two");
  });
  
  test("You can remove a key-value pair from an existing map and get a new one",function() {
    var map = new TreeMap([ {key: 1, value: "one" }, {key: 2, value: "two"}]).remove(2);
    ok(map.get(2).isEmpty() === true);
  });
  
  test("You can get a list containing all of the values",function() {
    var map = new TreeMap([
      { key: 1, value: "one"},
      { key: 2, value: "two"},
      { key: 3, value: "three"}
    ]);
    var values = map.values();
    ok(values.get(0).get() == "one");
    ok(values.get(1).get() == "two");
    ok(values.get(2).get() == "three");
  });
  
  test("You can get a list containing all of the keys",function() {
    var map = new TreeMap([
      { key: 1, value: "one"},
      { key: 2, value: "two"},
      { key: 3, value: "three"}
    ]);
    var keys = map.keys();
    ok(keys.get(0).get() == 1);
    ok(keys.get(1).get() == 2);
    ok(keys.get(2).get() == 3);
  });
  
  module("TreeMap - Traversable methods");
  
  test("You can map a TreeMap to another TreeMap", function() {
    var map = new TreeMap([
      {key: 1, value: 1},
      {key: 2, value: 2},
      {key: 3, value: 3}
    ]).map( function(kv){
      return { key: kv.key, value: kv.value*2 };
    });
    var shouldbe = new TreeMap([
      {key: 1, value: 2},
      {key: 2, value: 4},
      {key: 3, value: 6}
    ]);
    
    ok( map.get(1).get() == shouldbe.get(1).get() );    
    ok( map.get(2).get() == shouldbe.get(2).get() );    
    ok( map.get(3).get() == shouldbe.get(3).get() );    
  });
  
  test("You can flatMap a TreeMap to another TreeMap", function() {
    var map = new TreeMap([
      { key: 1, value: 1},
      { key: 4, value: 4}
    ]).flatMap( function(kv){ 
      return new TreeMap([
        { key: kv.key , value: kv.value},
        { key: kv.key +1, value: kv.value+1},
        { key: kv.key +2, value: kv.value+2}
      ]);
    });
    
    var shouldbe = new TreeMap([
      { key: 1, value: 1},
      { key: 2, value: 2},
      { key: 3, value: 3},
      { key: 4, value: 4},
      { key: 5, value: 5},
      { key: 6, value: 6}
    ]);
    
    ok( map.get(1).get() == shouldbe.get(1).get() );    
    ok( map.get(2).get() == shouldbe.get(2).get() );    
    ok( map.get(3).get() == shouldbe.get(3).get() );    
    ok( map.get(4).get() == shouldbe.get(4).get() );
    ok( map.get(5).get() == shouldbe.get(5).get() );
    ok( map.get(6).get() == shouldbe.get(6).get() );
  });

  test("You can filter a TreeMap", function() {
    var map = new TreeMap([
      { key: 1, value: 1},
      { key: 2, value: 2},
      { key: 3, value: 3},
      { key: 4, value: 4},
      { key: 5, value: 5},
      { key: 6, value: 6}
    ]).filter( function(kv) {
      return kv.key > 3;
    });
    
    var shouldbe = new TreeMap([
      { key: 4, value: 4},
      { key: 5, value: 5},
      { key: 6, value: 6}
    ]);
    
    ok( map.get(1).isEmpty() === true );    
    ok( map.get(2).isEmpty() === true );    
    ok( map.get(3).isEmpty() === true );    
    ok( map.get(4).get() == shouldbe.get(4).get() );
    ok( map.get(5).get() == shouldbe.get(5).get() );
    ok( map.get(6).get() == shouldbe.get(6).get() );
  });
  
});