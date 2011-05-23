$(document).ready(function(){
  
  var generic_multimap_test = function(name, Constructor, Collection) {
    
    module(name);
    
    var mm = new Constructor([ { key: 1, value: [1,2,3] }, { key: 2, value: 4 } ], Collection);
    
    test("Constructor", function() {
      ok( mm.containsKey(1) && mm.containsKey(2) );
      ok( equalsArr(mm.values().asArray(), [1,2,3,4]) );
    });

    test("insert", function() {
      var mm2 = mm.insert(1,10);
      ok ( equalsArr(mm2.get(1).asArray(), [1,2,3,10]) );
    });
    
    test("insertALl", function(){
       var mm2 = mm.insertAll(1,[10,11]);
       ok ( equalsArr(mm2.get(1).asArray(), [1,2,3,10,11]));
    });
    
    test("get", function() {
      ok ( equalsArr( mm.get(1).asArray(), [1,2,3] ));
      ok ( equalsArr( mm.get(99).asArray(), [] )); // no key -> empty list
    });
    
    test("remove", function() {
      var mm2 = mm.remove(1,2);
      ok ( equalsArr( mm2.get(1).asArray(), [1,3] ));
    });
    
    test("removeAll", function() {
      var mm2 = mm.removeAll(1);
      ok( equalsArr( mm2.values().asArray(), [4] ));      
    });
    
    test("values", function() {
      ok( equalsArr( mm.values().asArray(), [1,2,3,4] ));
    });
    
    test("keys", function() {
      ok( equalsArr( mm.keys().asArray(), [1,2] ));
    });
    
    test("multimap with a set doens't allow duplicates", function() {
      var mmSet = new Constructor([ { key: 1, value: [1,2,3,3] }, { key: 2, value: 4 } ], mugs.TreeSet);
      ok ( equalsArr( mmSet.values().asArray(), [1,2,3,4]));
      var mmSet2 = mmSet.insert(2,4);
      ok ( equalsArr( mmSet.values().asArray(), [1,2,3,4]));
    });
    
    /*
        Test the use of comparators 
    */
    
    // var Person = function(name,age){
    //         this.name = name;
    //         this.age  = age;
    //         return this;
    //     };
    //     
    //     var comp_func = function(obj1,obj2) {
    //         console.log("using custom comparator");
    //         if (obj1.name < obj2.name) {
    //             return -1;
    //         } else if (obj1.name > obj2.name) {
    //             return 1;
    //         } else {
    //             return 0;
    //         }
    //     };
    //     
    //     var people = [new Person("Mads",21),new Person("Eva",21)];
    //     
    //     var kvs = [
    //         { "key" : people[0], "value" : [1,2,3] },
    //         { "key" : people[1],  "value" : [4,5,6] }
    //     ];
    //     
    //     console.log("Creating map");
    //     var map = new Constructor(kvs, Collection, comp_func);
    //     console.log(map);
    //     
    //     module("MultimapOrdered");
    //     
    //     test("Get (with comparator)",function() {
    //         ok( equalsArr(map.get(people[0]).get().asArray(), [1,2,3]));
    //         console.log(map.get(people[0]).get().asArray());
    //         ok( equalsArr(map.get(people[1]).get().asArray(), [4,5,6]));
    //         console.log(map.get(people[0]).get().asArray());
    //     });
    
  };
    
  generic_multimap_test("Multimap (List)",    mugs.Multimap, mugs.List);
  generic_multimap_test("Multimap (TreeSet)", mugs.Multimap, mugs.TreeSet);
  generic_multimap_test("Multimap (LLRBSet)", mugs.Multimap, mugs.LLRBSet);
  
});