/*
  Test the checks that a specific implementation conforms to the Indexed interface 
*/

$(document).ready(function() {
    
    var implements_Indexed = function(name, Constructor, support){
        
        module(name + " (Indexed)");
        
        test("get",function() {
            var col = new Constructor(support.dflt.input);
            ok( col.get(0).get() == 1 );
            ok( col.get(1).get() == 2 );
            ok( col.get(2).get() == 3 );
        });
        
        test("get, negative index", function() {
            var col = new Constructor(support.dflt.input);
            ok(col.get(-1).isEmpty());
        });

        test("indexOf", function() {
            var col = new Constructor(support.dflt.input);
            ok( col.indexOf(2).get() == 1);
        });
        
        test("lastIndexOf", function() {
            var col = new Constructor(support.lastIndexOf.input);
            ok( col.lastIndexOf(2).get() == support.lastIndexOf.expected);
        });

        test("findIndex", function() {
            var col = new Constructor(support.dflt.input);
            var index = col.findIndex(function(item){ return item > 1; });
            ok( index.get() == 1);
        });
        
        test("findLastIndex", function() {
            var col = new Constructor(support.findLastIndex.input);
            var index = col.findLastIndex(function(item){ return item > 1; }).get();
            ok( index == support.findLastIndex.expected);
        });
        
        test("update",function() {
           var col = new Constructor(support.dflt.input);
           ok( col.update(0,10).get(0).get(), 10);
           ok( col.update(1,10).get(1).get(), 10);
           ok( col.update(2,10).get(2).get(), 10);
        });
        
        test("removeAt", function() {
            var col = new Constructor(support.dflt.input);
            ok( equalsArr( col.removeAt(0).asArray(), [2,3] ));
            ok( equalsArr( col.removeAt(2).asArray(), [1,2]));
        });
    };
    
    support = {
        'dflt' : {
            'input' : [1,2,3]
        },
        'lastIndexOf' : {
            'input' : [1,2,3,2],
            'expected' : 3
        },
        'findLastIndex' : {
            'input' : [1,2,3,2],
            'expected' : 3
        }
    };
    
    setSupport = {
        'dflt' : support.dflt,
        'lastIndexOf' : {
            'input' : support.lastIndexOf.input,
            'expected' : 1
        },
        'findLastIndex' : {
            'input' : support.lastIndexOf.input,
            'expected' : 2
        }
    };
    
    implements_Indexed("List",    mugs.List,    support);
    implements_Indexed("Stack",   mugs.Stack,   support);
    implements_Indexed("Queue",   mugs.Queue,   support);
    implements_Indexed("TreeSet", mugs.TreeSet, setSupport);
    implements_Indexed("LLRBSet", mugs.LLRBSet, setSupport);
});