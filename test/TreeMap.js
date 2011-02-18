$(document).ready(function(){
  
  module("TreeMap");
  
  test("You can create a map with a single key-value pair", function() {
    var map = new TreeMap(1, "one").insert(4,"four").insert(2,"two").insert(3,"three");
    ok(map.get(1).get() == "one", "The element with key 1 has the value 'one'");
    ok(map.get(4).get() == "four", "The element with key 1 has the value 'four'");
    ok(map.get(3).get() == "three", "The element with key 1 has the value 'three'");
    ok(map.get(2).get() == "two", "The element with key 1 has the value 'two'");
    ok(map.get(10).isEmpty() === true, "Asking for a key that doesn't exist returns None");
  });
  
  
});