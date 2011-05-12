$(document).ready(function(){
  
  var generic_multimap_test = function(name, Constructor, Collection) {
    
    module(name);
    
    var mm = new Constructor([ { key: 1, value: [1,2,3] }, { key: 2, value: 4 } ], Collection);
    
    test("Constructor", function() {
      ok( mm.contains(1) && mm.contains(2) );
      ok( equalsArr(mm.values().asArray(), [1,2,3,4]) );
    });

    test("insert", function() {
      var mm2 = mm.insert(1,10);
      ok ( equalsArr(mm2.get(1).asArray(), [1,2,3,10]) );
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
    
  };
    
  generic_multimap_test("Multimap (List)",    mugs.Multimap, mugs.List);
  generic_multimap_test("Multimap (TreeSet)", mugs.Multimap, mugs.TreeSet);
  generic_multimap_test("Multimap (LLRBSet)", mugs.Multimap, mugs.LLRBSet);
  
});