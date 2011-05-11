/*
  Test the checks that a specific implementation conforms to the Sequenced interfaces 
*/

$(document).ready(function() {

    var implements_Sequenced = function(name, Constructor) {
        
        module(name + " (Sequenced)");
      
        test("first",function() {
            var col = new Constructor([1,2,3]);
            ok(col.first().get() == 1);
        });

        test("last",function() {
            var col = new Constructor([1,2,3]);
            ok(col.last().get() == 3);
        });

        test("head",function() {
            var col = new Constructor([1,2,3]);
            ok( col.head() == 1);
        });

        test("tail",function() {
            var col = new Constructor([1,2,3]);
            ok( equalsArr(col.tail().asArray(), [2,3]));
        });
        
        test("foldLeft", function() {
            
        });
        
        test("foldRight", function() {
            
        });
    }; 
    
    implements_Sequenced("List",  mugs.List);
    implements_Sequenced("Stack", mugs.Stack);
    implements_Sequenced("Queue", mugs.Queue);
    implements_Sequenced("TreeSet", mugs.TreeSet);
});