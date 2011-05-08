$(document).ready(function() {
  
  /*
    Currently only works in Safari. This is because Chrome & Firefox won't allow scripts
    to be loaded using file:// 
  */
  
  generic_parallel_set_test = function(name, Constructor) {
    
    module(name);
    
    var INPUT_ARR    = [1,2,3,4,5,6,7,8,9,10],
        DOUBLE_ARR   = [2,4,6,8,10,12,14,16,18,20],
        FILTERED_ARR = [5,6,7,8,9,10];
        
    var pset = new mugs.parallel.Set(INPUT_ARR);
    
    // Map test 
    pset.map(
      function(e){
        return e*2;
      }, 
      function(e){ 
        test("map", function() {
          console.log("map : " + e.values().asArray());
          ok( equalsArr( e.values().asArray(), DOUBLE_ARR ));
        });
      }
    );
    
    // Filter test 
    pset.filter(
      function(item) {
        return item >= 5;
      },
      function(set) {
        test("filter", function() {
          console.log("filter : " + set.values().asArray());
          ok( equalsArr( set.values().asArray(), FILTERED_ARR ));
        });
      }
    );
    
    // pset.flatMap(
    //    function(item) {
    //      console.log(item);
    //      return new mugs.parallel.Set([item*2,item*2+1]);
    //    },
    //    function(set) {
    //      test("flatMap",function() {
    //        console.log("flatMap: " + set.values().asArray());
    //      });
    //    }
    //  );
  };
  
  generic_parallel_set_test("PrallelSet", mugs.parallel.Set);
  
});