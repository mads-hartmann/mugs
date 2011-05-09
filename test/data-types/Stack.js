$(document).ready(function(){

    var List = mugs.List;

    var implements_Stack = function(name, Stack){

        module(name);

        test("constructor", function() {
            var stack = new Stack([1,2,3,4,5]);      
            ok( equalsArr( stack.asArray(), [1,2,3,4,5]));

        });

        test("pop" ,function() {
            var stack = new Stack([1,2,3,4,5]).pop(),
            values = stack.values();

            ok(!values.get(0).isEmpty());
            ok(!values.get(1).isEmpty());
            ok(!values.get(2).isEmpty());
            ok(!values.get(3).isEmpty());
            ok(values.get(4).isEmpty());
        });

        test("push",function() {
            var stack = new Stack([1,2,3]).push(4),
            values = stack.values();
            ok(!values.get(0).isEmpty());
            ok(!values.get(1).isEmpty());
            ok(!values.get(2).isEmpty());
            ok(!values.get(3).isEmpty());
            ok(values.get(4).isEmpty());
        });

        test("top", function() {
            var stack = new Stack([1,2,3]);
            ok(stack.top() === 1);
        });
        
        test("pushAll", function() {
            var stack = new Stack([1,2,3]).pushAll([4,5]);
            ok( equalsArr( stack.asArray(), [5,4,1,2,3]));
            
        });
    };

    implements_Stack("Stack", mugs.Stack);

});