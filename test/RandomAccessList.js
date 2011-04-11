$(document).ready(function(){

  RandomAccessList = mugs.RandomAccessList;
  
  module("Random Access List");
  
  test("It is possible to create a RAL using multiple arguments (5)", function() {
    var ral = new RandomAccessList(1,2,3,4,5);
    ok(ral.get(0) == 1);
    ok(ral.get(1) == 2);
    ok(ral.get(2) == 3);
    ok(ral.get(3) == 4);
    ok(ral.get(4) == 5);
  });
  
  test("It is possible to create a RAL using multiple arguments (10)", function() {
    var ral = new RandomAccessList(1,2,3,4,5,6,7,8,9,10);
    ok(ral.get(0) == 1);
    ok(ral.get(1) == 2);
    ok(ral.get(2) == 3);
    ok(ral.get(3) == 4);
    ok(ral.get(4) == 5);
    ok(ral.get(5) == 6);
    ok(ral.get(6) == 7);
    ok(ral.get(7) == 8);
    ok(ral.get(8) == 9);
    ok(ral.get(9) == 10);
  });
  
  test("The structure of the items is valid" , function() {
    var ral = new RandomAccessList(1,2,3,4,5,6,7,8,9,10);
    
    var trees = ral.__trees ;
    
    var first  = trees.get(0).get();
    var second = trees.get(1).get();
    
    ok(first.item == 1);
    ok(first.left.item == 2);
    ok(first.right.item == 3);
    ok(second.item == 4);
    ok(second.left.item == 5);
    ok(second.left.left.item == 6);
    ok(second.left.right.item == 7);
    ok(second.right.item == 8);
    ok(second.right.left.item == 9);
    ok(second.right.right.item == 10);
  });
  
  test("It's possible to update an item in the collection", function() {
    var ral = new RandomAccessList(1,2,3,4,5,6,7,8,9,10);
    var ralReversed = ral.update(0,10)
                         .update(1,9)
                         .update(2,8)
                         .update(3,7)
                         .update(4,6)
                         .update(5,5)
                         .update(6,4)
                         .update(7,3)
                         .update(8,2)
                         .update(9,1);
     ok(ralReversed.get(0) == 10);
     ok(ralReversed.get(1) == 9);
     ok(ralReversed.get(2) == 8);
     ok(ralReversed.get(3) == 7);
     ok(ralReversed.get(4) == 6);
     ok(ralReversed.get(5) == 5);
     ok(ralReversed.get(6) == 4);
     ok(ralReversed.get(7) == 3);
     ok(ralReversed.get(8) == 2);
     ok(ralReversed.get(9) == 1);
  });
  
  test("It is possible to read the size of the list", function() {
    ral = new RandomAccessList(1,2,3,4,5,6,7,8,9,10);
    ok(ral.size() == 10);
  });
  
  test("It's possible to prepend a item to a list" , function() {
    ral = new RandomAccessList(2).prepend(1);
    ok(ral.size() == 2);
    ok(ral.get(0) == 1);
    ok(ral.get(1) == 2);
  });
  
  test("It's possible to read the head item of a list", function() {
    ral = new RandomAccessList(2);
    ok(ral.head() == 2);
  });
  
  test("It's possible to get the tail of a list", function() {
    ral = new RandomAccessList(1,2,3,4,5,6).tail();
    ok(ral.size() == 5);
    ok(ral.get(0) == 2);
  });
  
  // test("It is possible to remove a element from the list", function() {
  //     var ral = new RandomAccessList(1,2,3,4,5,6,7,8,9,10);
  //     var updated = ral.remove(0);
  //     
  //     first = updated.__trees.get(0).get();
  //     second = updated.__trees.get(1).get();
  //     third = updated.__trees.get(2).get();
  //     
  //     ok(updated.size() == 9);
  //     
  //     ok(first.item == 2);
  //     ok(first.isLeaf);
  //     ok(second.item == 3);
  //     ok(second.isLeaf);
  //     ok(third.item == 4);
  //     ok(third.left.item == 5);
  //     ok(third.left.left.item == 6);
  //     ok(third.left.right.item == 7);
  //     ok(third.right.item == 8);
  //     ok(third.right.left.item == 9);
  //     ok(third.right.right.item == 10);
  //     
  //     var updated2 = ral.remove(1);
  //     ok(updated2.size() == 9);
  //     ok(updated2.get(0) == 1);
  //     ok(updated2.get(1) == 3);
  //     ok(updated2.get(2) == 4);
  //     ok(updated2.get(3) == 5);
  //     ok(updated2.get(4) == 6);
  //     ok(updated2.get(5) == 7);
  //     ok(updated2.get(6) == 8);
  //     ok(updated2.get(7) == 9);
  //     ok(updated2.get(8) == 10);
  //   });
  
});