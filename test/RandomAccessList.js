$(document).ready(function(){
  
  module("Random Access List");
  
  test("It is possible to create a RAL using multiple arguments (5)", function() {
    ral = new RandomAccessList(1,2,3,4,5);
    ok(ral.lookup(0) == 1);
    ok(ral.lookup(1) == 2);
    ok(ral.lookup(2) == 3);
    ok(ral.lookup(3) == 4);
    ok(ral.lookup(4) == 5);
  });
  
  test("It is possible to create a RAL using multiple arguments (10)", function() {
    ral = new RandomAccessList(1,2,3,4,5,6,7,8,9,10);
    ok(ral.lookup(0) == 1);
    ok(ral.lookup(1) == 2);
    ok(ral.lookup(2) == 3);
    ok(ral.lookup(3) == 4);
    ok(ral.lookup(4) == 5);
    ok(ral.lookup(5) == 6);
    ok(ral.lookup(6) == 7);
    ok(ral.lookup(7) == 8);
    ok(ral.lookup(8) == 9);
    ok(ral.lookup(9) == 10);
  });
  
  test("It's possible to update an item in the collection", function() {
    ral = new RandomAccessList(1,2,3,4,5,6,7,8,9,10);
    ralReversed = ral.update(0,10)
                     .update(1,9)
                     .update(2,8)
                     .update(3,7)
                     .update(4,6)
                     .update(5,5)
                     .update(6,4)
                     .update(7,3)
                     .update(8,2)
                     .update(9,1);
     ok(ralReversed.lookup(0) == 10);
     ok(ralReversed.lookup(1) == 9);
     ok(ralReversed.lookup(2) == 8);
     ok(ralReversed.lookup(3) == 7);
     ok(ralReversed.lookup(4) == 6);
     ok(ralReversed.lookup(5) == 5);
     ok(ralReversed.lookup(6) == 4);
     ok(ralReversed.lookup(7) == 3);
     ok(ralReversed.lookup(8) == 2);
     ok(ralReversed.lookup(9) == 1);
  });
  
  test("It is possible to read the size of the list", function() {
    ral = new RandomAccessList(1,2,3,4,5,6,7,8,9,10);
    ok(ral.size() == 10);
  });
  
});