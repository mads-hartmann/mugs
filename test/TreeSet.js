$(document).ready(function(){

  TreeSet = mugs.TreeSet;
  
  module("TreeSet");
  
  test("It's possible to create a set using an array", function() {
    var set = new TreeSet([1,2,3,4,5]);
    ok(set !== undefined);
  });
  
  test("It's possible to check if the set contains a specific element",function() {
    var set = new TreeSet([1,2,3,4,5]);
    ok(set.contains(3));
  });
  
  test("It's possible to insert a new element to the set",function() {
    var set = new TreeSet([1,2,3,4,5]).insert(6);
    ok(set.contains(6));
  });
  
  test("It's possible to remove an element from the set",function() {
    var set = new TreeSet([1,2,3,4,5]).remove(3);
    ok(!set.contains(3));
  });
  
  test("When inserting an element that already exists it shouldn't be duplicated", function() {
    var set = new TreeSet([1,2,3,4,5]).insert(5);
    ok(set.contains(5));

    var values = set.values();
    ok(!values.get(0).isEmpty());
    ok(!values.get(1).isEmpty());
    ok(!values.get(2).isEmpty());
    ok(!values.get(3).isEmpty());
    ok(!values.get(4).isEmpty());
    ok(values.get(6).isEmpty());
  });
  
  module("TreeSet - Traversable methods");
  
  test("You can map a TreeSet to another TreeSet", function() {
    var set = new TreeSet([1,2,3,4]).map( function(elem){ return elem*2; }),
        shouldbeSet = new TreeSet([2,4,6,8]),
        list = set.values(),
        shouldbe = shouldbeSet.values();
            
    ok( list.get(0).get() == shouldbe.get(0).get() );    
    ok( list.get(1).get() == shouldbe.get(1).get() );    
    ok( list.get(2).get() == shouldbe.get(2).get() );    
    ok( list.get(3).get() == shouldbe.get(3).get() );    
  });
  
  test("You can flatMap a TreeSet to another TreeSet", function() {
    var set = new TreeSet([1,3]).flatMap( function(elem){ 
          return new TreeSet([elem,elem+1]);
        }),
        shouldbeSet = new TreeSet([1,2,3,4]),
        list = set.values(),
        shouldbe = shouldbeSet.values(); 
    
    ok( list.get(0).get() == shouldbe.get(0).get() );    
    ok( list.get(1).get() == shouldbe.get(1).get() );    
    ok( list.get(2).get() == shouldbe.get(2).get() );    
    ok( list.get(3).get() == shouldbe.get(3).get() );
  });

  test("You can filter a TreeSet", function() {
    var set = new TreeSet([1,2,3,4,5,6,7,8,9,10]).filter( function(elem){ 
          return elem >= 5; 
        }),
        list = set.values();  
    
    
    ok( list.get(0).get() == 5 );    
    ok( list.get(1).get() == 6 );    
    ok( list.get(2).get() == 7 );
    ok( list.get(3).get() == 8 );
    ok( list.get(4).get() == 9 );
    ok( list.get(5).get() == 10 );
  });
  
});