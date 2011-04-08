$(document).ready(function(){

    module("LLRedBlackTree");

    test("", function() {
        var node = new LLRBNode(1,1);
        ok(node.left.isEmpty());
        ok(node.right.isEmpty());
    });

    test("You can insert a new key/value pair into the tree", function() {
        var node = new LLRBNode(1,1).insert(2,2);

        ok(node.key == 2);
        ok(node.left.get().key == 1);

    });

    test("You can search for node with a specific key", function() {
        var node = new LLRBNode(1,1).insert(2,2);

        ok(node.get(1).get() == 1);
        ok(node.get(2).get() == 2);
        ok(node.get(3).isEmpty());

    });

    test("You can remove a key/value pair from the tree",function() {
        var node = new LLRBNode(1,1).insert(2,2);
        var newNode = node.remove(1);

        ok(newNode.get(2).get() === 2);
        ok(newNode.get(1).isEmpty());
    });

    test("More removals",function(){

        var node = new LLRBNode(1,1).insert(50,50)
            .insert(3,3)
            .insert(4,4)
            .insert(7,7)
            .insert(9,9)
            .insert(20,20)
            .insert(18,18)
            .insert(2,2)
            .insert(71,71)
            .insert(42,42)
            .insert(88,88)

        var n1 = node.remove(7);
        var n2 = node.remove(3);
        var n3 = node.remove(1);
    });

    test("Get the min key",function(){
        var node = new LLRBNode(3,3)
            .insert(2,2)
            .insert(7,7)
            .insert(4,4)
            .insert(1,1);
        var min = node.minKey();
        ok(min == 1);
    });

    test("The structure should be valid after insertion (1)",function(){

        var node = new LLRBNode(1,1).insert(2,2).insert(3,3);

        ok(node.key == 2);
        ok(node.left.get().key == 1);
        ok(node.right.get().key == 3);
    });

    test("The structure should be valid after insertion (2)",function(){

        var node = new LLRBNode(1,1)
            .insert(2,2)
            .insert(3,3)
            .insert(4,4)
            .insert(5,5)
            .insert(6,6)
            .insert(7,7)
            .insert(8,8)
            .insert(9,9)
            .insert(10,10)
            .insert(11,11)
            .insert(12,12);
       
       ok(node.count() == 12);
       ok(node.checkMaxDepth());

    });


    // test("The structure should be valid after insertion (3)",function(){

    //      var node = new LLRBNode(1,1)
    //         .insert(50,50)
    //         .insert(3,3)
    //         .insert(4,4)
    //         .insert(7,7)
    //         .insert(9,9)
    //         .insert(20,20)
    //         .insert(18,18)
    //         .insert(2,2)
    //         .insert(71,71)
    //         .insert(42,42)
    //         .insert(88,88);

    //     ok(node.get(1).get() == 1);
    //     ok(node.get(2).get() == 2);
    //     ok(node.get(3).get() == 3);
    //     ok(node.get(4).get() == 4);
    //     ok(node.get(7).get() == 7);
    //     ok(node.get(9).get() == 9);
    //     ok(node.get(18).get() == 18);
    //     ok(node.get(20).get() == 20);
    //     ok(node.get(42).get() == 42);
    //     ok(node.get(50).get() == 50);
    //     ok(node.get(71).get() == 71);
    //     ok(node.get(88).get() == 88);

    //     // TODO: This is NOT correctly balanced :-(
    //     node.removeMinKey();

    // });

    // test("You can remove the min key",function(){
    //      var node = new LLRBNode(1,1)
    //         .insert(50,50)
    //         .insert(3,3)
    //         .insert(4,4)
    //         .insert(7,7)
    //         .insert(9,9)
    //         .insert(20,20)
    //         .insert(18,18)
    //         .insert(2,2)
    //         .insert(71,71)
    //         .insert(42,42)
    //         .insert(88,88);


    //     var n1 = node.removeMinKey();

    //     ok(n1.get(1).isEmpty());

    //     var n2 = n1.removeMinKey();
    //     var n3 = n2.removeMinKey();
    // });

    test("you can override ta value",function(){
        var node = new LLRBNode(10,10).insert(10,8);
        ok(node.get(10).get() == 8);
    });

});