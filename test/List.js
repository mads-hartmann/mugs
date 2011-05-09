$(document).ready(function(){

  var generic_list_test = function(name, List){

    module(name);

    test("It's possible to create a list passing an array", function() {
      var list = new List([1,2,3]);
      ok(list.head() == 1, "First element is 1");
      ok(list.tail().head() == 2, "Second element is 2");
      ok(list.tail().tail().head() == 3, "Third element is 3");
    });

    test("It's possible to create a new list by appending a value to an existing list", function() {
      var list = new List([1,2]).append(3);
      ok(list.head() == 1, "First element is 1");
      ok(list.tail().head() == 2, "Second element is 2");
      ok(list.tail().tail().head() == 3, "Third element is 3");
    });

    test("You can chain append method calls if you want", function() {
      var list = new List([1,2]).append(3).append(4);
      ok(list.head() == 1, "First element is 1");
      ok(list.tail().head() == 2, "Second element is 2");
      ok(list.tail().tail().head() == 3, "Third element is 3");
      ok(list.tail().tail().tail().head() == 4, "Forth element is 4");
    });

    test("It's possible to create a new list by appending a list to an existing list", function() {
      var list = new List([1,2]).appendAll([3,4]);
      ok(list.head() == 1, "First element is 1");
      ok(list.tail().head() == 2, "Second element is 2");
      ok(list.tail().tail().head() == 3, "Third element is 3");
      ok(list.tail().tail().tail().head() == 4, "Forth element is 4");
    });

    test("You can create a new list by prepending a value to an existing list", function() {
      var list = new List([1,2]).prepend(3);
      ok(list.head() == 3, "First element is 3");
      ok(list.tail().head() == 1, "Second element is 1");
      ok(list.tail().tail().head() == 2, "Third element is 2");
    });

    test("You can create a new list by prepending a list to an existing list", function() {
      var list = new List([1,2]).prependAll([3,4]);
      ok(list.head() == 3, "First element is 3");
      ok(list.tail().head() == 4, "Second element is 4");
      ok(list.tail().tail().head() == 1, "Third element is 1");
      ok(list.tail().tail().tail().head() == 2, "Forth element is 2");
    });

    test("You can access the first and last elements", function() {
      var list = new List([1,2,3,4,5,6,7,8,9,10]);
      ok(list.first().get() == 1, "First element is 1");
      ok(list.last().get() == 10, "Last element is 10");
    });

    test("You can read the elements by their location in the list", function() {
      var list = new List([1,2,3,4,5,6,7,8,9,10]);
      ok(list.get(0).get() == 1, "1. element is 1");
      ok(list.get(5).get() == 6, "6. element is 6");
      ok(list.get(12).isEmpty() === true, "If the element doesn't exist it returns None()");
    });

    test("You can update a element in the list.", function() {
      var list = new List([1,2,3,4,5,6,7,8,9,10]).update(4,90);
      ok(list.get(4).get() == 90);
      ok(list.get(5).get() == 6);
    });

    test("removeAt", function() {
      var list = new List([1,2,3,4,5]).removeAt(2);
      ok(list.get(2).get() == 4);
    });

    test("You can fold the list either left or right", function() {
      var list = new List([1,2,3,4,5,6,7,8,9,10]);
      var sum = list.foldLeft(0)(function(acc, value) {
        return acc + value;
      });
      var product = list.foldRight(1)(function(acc, value) {
        return acc * value;
      });
      ok(sum == 55, "The sum of all integers from 1 to 10 is 55");
      ok(product == 3628800, "The product of all integers from 1 to 10 is 3628800" );
    });

    test("You can reverse a list", function() {
      var list = new List([1,2,3]).reverse(),
      shouldBe = new List([3,2,1]);

      ok(list.get(0).get() == shouldBe.get(0).get());
      ok(list.get(1).get() == shouldBe.get(1).get());
      ok(list.get(2).get() == shouldBe.get(2).get());
    });

    test("findIndexOf", function() {
      var list = new mugs.List([1,2,3,4,5]);
      ok(list.findIndexOf(function(item){ return (item > 3); }) == 3);
      ok(list.findIndexOf(function(item){ return (item > 1); }) == 1);
      ok(list.findIndexOf(function(item){ return (item > 0); }) === 0);
      ok(list.findIndexOf(function(item){ return (item > 10); }) == -1); 
    });

  };

  generic_list_test("List" , mugs.List);


});