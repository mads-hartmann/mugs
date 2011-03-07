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
  
  test("You can get a list containing all of the keys",function() {
    var map = new TreeMap([
      { key: 1, value: "one"},
      { key: 2, value: "two"},
      { key: 3, value: "three"}
    ]);
    var values = map.values();
    ok(values.get(0) == "one");
    ok(values.get(1) == "two");
    ok(values.get(2) == "three");
  });
  
  test("You can get a list containing all of the values",function() {
    
  });
  
  
  
});