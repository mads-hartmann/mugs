$(document).ready(function(){
  
  module("TreeSet");
  
  test("It's possible to create a set using an array", function() {
    var set = new TreeSet([1,2,3,4,5]);
    ok(set !== undefined);
  });
  
  test("It's possible to check if the set contains a specific element",function() {
    var set = new TreeSet([1,2,3,4,5]);
    ok(set.contains(3) === true);
  });
  
  test("It's possible to insert a new element to the set",function() {
    var set = new TreeSet([1,2,3,4,5]).insert(6);
    ok(set.contains(6) === true);
  });
  
  test("It's possible to remove an element from the set",function() {
    var set = new TreeSet([1,2,3,4,5]).remove(3);
    ok(set.contains(3) === false);
  });
  
});