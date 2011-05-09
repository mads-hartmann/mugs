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

        test("append",function() {
            var col = new Constructor([1,2,3]);
            ok( equalsArr(col.append(4).asArray() , [1,2,3,4]));
        });

        test("appendAll",function() {
            var col = new Constructor([1,2,3]);
            ok( equalsArr( col.appendAll([4,5]).asArray(), [1,2,3,4,5]));
        }); 

        test("prepend",function() {
            var col = new Constructor([1,2,3]);
            ok( equalsArr(col.prepend(4).asArray(), [4,1,2,3]));
        });

        test("prependAll",function() {
            var col = new Constructor([1,2,3]);
            ok( equalsArr(col.prependAll([4,5]).asArray(), [4,5,1,2,3]));
        });

        test("head",function() {
            var col = new Constructor([1,2,3]);
            ok( col.head() == 1);
        });

        test("tail",function() {
            var col = new Constructor([1,2,3]);
            ok( equalsArr(col.tail().asArray(), [2,3]));
        });

        test("reverse",function() {
            var col = new Constructor([1,2,3]);
            ok( equalsArr( col.reverse().asArray(), [3,2,1] ));
        }); 
    }; 
    
    implements_Sequenced("List",  mugs.List);
    implements_Sequenced("Stack", mugs.Stack);
    implements_Sequenced("Queue", mugs.Queue);
});