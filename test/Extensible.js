/*
  Test the checks that a specific implementation conforms to the Extensible interfaces 
*/

$(document).ready(function() {
    
    var implements_Extensible = function(name, Constructor, support) {
        
        module(name + "(Extensible)");
        
        test("insert", function() {
            var col = new Constructor([1,2,3]);
            var col2 = col.insert(4);
            ok( equalsArr(col2.asArray(), support.insert.expected));
        });
        
        test("insertAll", function() {
            var col = new Constructor([1,2,3]).insertAll([4,5,6]);
            ok( equalsArr( col.asArray(), support.insertAll.expected));
        });
        
        test("remove", function() {
            var col = new Constructor([1,2,3,4,5]);
            
            ok( equalsArr( col.remove(3).asArray(), [1,2,4,5]));
            ok( equalsArr( col.remove(2).asArray(), [1,3,4,5]));            
        });
        
        test("removeAll", function() {
            var col = new Constructor([1,2,3,4]).removeAll([1,2,3]);
            ok( equalsArr( col.asArray(), [4]));
        });
    };

    support = {
        'insert' : {
            'expected' : [1,2,3,4]
        },
        'insertAll' : {
            'expected' : [1,2,3,4,5,6]
        }
    };
    
    stack = {
        'insert' : {
            'expected' : [4,1,2,3]
        },
        'insertAll' : {
            'expected' : [6,5,4,1,2,3]
        }
    };

    implements_Extensible("List",    mugs.List,    support);
    implements_Extensible("TreeSet", mugs.TreeSet, support);
    implements_Extensible("LLRBSet", mugs.LLRBSet, support);
    implements_Extensible("Stack",   mugs.Stack,   stack);
    implements_Extensible("Queue",   mugs.Queue,   support);
    implements_Extensible("HashSet", mugs.HashSet, support);
    // implements_Extensible("RandomAccessList", mugs.RandomAccessList);

});