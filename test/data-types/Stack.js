$(document).ready(function(){

  var List = mugs.List;

  var generic_stack_test = function(name, Stack){

    module(name);

    test("You can create a Stack using multiple arguments", function() {
      var stack = new Stack(1,2,3,4,5),
      values = stack.values(),
      shouldBe = new List([5,4,3,2,1]);

      ok(values.get(0).get() === shouldBe.get(0).get());
      ok(values.get(1).get() === shouldBe.get(1).get());
      ok(values.get(2).get() === shouldBe.get(2).get());
      ok(values.get(3).get() === shouldBe.get(3).get());
    });

    test("You can pop a value from the stack" ,function() {
      var stack = new Stack(1,2,3,4,5).pop(),
      values = stack.values();

      ok(!values.get(0).isEmpty());
      ok(!values.get(1).isEmpty());
      ok(!values.get(2).isEmpty());
      ok(!values.get(3).isEmpty());
      ok(values.get(4).isEmpty());
    });

    test("You can push a value onto the stack",function() {
      var stack = new Stack(1,2,3).push(4),
      values = stack.values();
      ok(!values.get(0).isEmpty());
      ok(!values.get(1).isEmpty());
      ok(!values.get(2).isEmpty());
      ok(!values.get(3).isEmpty());
      ok(values.get(4).isEmpty());
    });

    test("You can read the top value of the stack", function() {
      var stack = new Stack(1,2,3);
      ok(stack.top() === 3);
    });

  }

  generic_stack_test("Stack", mugs.Stack);

});