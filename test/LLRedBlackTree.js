$(document).ready(function(){

    LLRBNode = mugs.LLRBNode;
    LLRBLeaf = mugs.LLRBLeaf;

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
            .insert(88,88);

        var n1 = node.remove(7);
        var n2 = node.remove(3);
        var n3 = node.remove(1);
    });

    test("Removal values", function(){
      var node = new LLRBNode(2,2).insert(1,1).insert(3,3);
      var n2 = node.remove(2);
      ok(n2.get(1).get() === 1);
      ok(n2.get(3).get() === 3);
    });


    test("Test increasing", function(){
      var total = 100;
      var item;
      var tree = new LLRBNode(1,1);
      for (item = 2; item < total ; item++) {
        tree = tree.insert(item,item);
      }
      ok(tree.checkMaxDepth());
      for (item = 2; item < total ; item++) {
        tree = tree.remove(item);
      }
      ok(tree.checkMaxDepth());
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


    test("Rotate left leaves the tree in a valid state",function(){
        var node = new LLRBNode(4,4,false,
                                new Some(new LLRBNode(2,2,false,new None(), new None())),
                                new Some(new LLRBNode(7,7,true,
                                                      new Some(new LLRBNode(5,5,false,new None(),new None())),
                                                      new Some(new LLRBNode(8,8,false,new None(),new None())))));
        
        var node2 = node.rotateLeft(node);
        ok(node2.count() == 5);
        ok(node2.checkMaxDepth());
    });

    test("Rotate right leaves the tree in a valid state", function(){
        var node = new LLRBNode(7,7,false,
                               new Some(new LLRBNode(4,4,true,
                                                    new Some(new LLRBNode(2,2,false, new None(), new None())),
                                                    new Some(new LLRBNode(5,5,false, new None(), new None())))),
                               new Some(new LLRBNode(8,8,false, new None(), new None())));

        var node2 = node.rotateRight();
        ok(node2.count() == 5);
        ok(node2.key == 4);
        ok(node2.left.get().key == 2);
        ok(node2.right.get().key == 7);
        ok(node2.right.get().left.get().key == 5);
        ok(node2.right.get().right.get().key == 8);

    });

    test("The structure should be valid after insertion (3)",function(){

        var node = new LLRBNode(1,1)
            .insert(50,50)
            .insert(3,3)
            .insert(4,4)
            .insert(7,7)
            .insert(9,9);

       ok(node.count() == 6);
       ok(node.checkMaxDepth());

       var n2 = node
            .insert(20,20)
            .insert(18,18)
            .insert(2,2);

       ok(n2.count() == 9);
       ok(n2.checkMaxDepth());

       var n3 = n2
            .insert(71,71)
            .insert(42,42)
            .insert(88,88);

        ok(n3.count() == 12);
        ok(n3.checkMaxDepth());
    });

    test("You can remove the min key",function(){
         var node = new LLRBNode(1,1)
            .insert(50,50)
            .insert(3,3)
            .insert(4,4)
            .insert(7,7)
            .insert(9,9)
            .insert(20,20)
            .insert(18,18)
            .insert(2,2)
            .insert(71,71)
            .insert(42,42)
            .insert(88,88);

        ok(node.count() == 12);
        ok(node.checkMaxDepth());

        var n1 = node.removeMinKey();

        ok(n1.count() == 11);
        ok(n1.checkMaxDepth());
        
        var n2 = n1.removeMinKey();
   
        ok(n2.count() == 10);
        ok(n2.checkMaxDepth());
    });

    test("you can override ta value",function(){
        var node = new LLRBNode(10,10).insert(10,8);
        ok(node.get(10).get() == 8);
    });
    
    test("removing the last element returns an empty tree",function() {
       var node = new LLRBNode(10,10).remove(10);
       ok(node.isEmpty());
    });
    
    test("leaf.removeMinKey",function() {
        var leaf = new LLRBLeaf();
        ok(leaf.removeMinKey() === leaf);
    });
    
    test("leaf.get()",function() {
       var leaf = new LLRBLeaf();
       ok(leaf.get("something").isEmpty());
    });
    
    test("leaf.values()",function() {
        var leaf = new LLRBLeaf();
        ok(leaf.values().isEmpty());
    });
    
    test("leaf.values()",function() {
        var leaf = new LLRBLeaf();
        ok(!leaf.containsKey("abc"));
    });
    
    test("leaf.count()",function() {
        var leaf = new LLRBLeaf();
        ok(leaf.count() === 0);
    });
    
    test("leaf.remove()",function() {
        var leaf = new LLRBLeaf();
        ok(leaf.remove("something") === leaf);
    });
    
    test("leaf.minKey()",function() {
        var leaf = new LLRBLeaf();
        var rslt = false;
        try{
            leaf.minKey();
        }catch(e){
            rslt = true;
        }
        
        ok(rslt);
    });
    
    test("insertion and removal of 1000 items", function() {
        var map = new mugs.LLRBMap(), i;
        for ( i = 0 ; i < 1000 ; i++ ) {
            map = map.insert(i,i);
        } 
        ok(map.size() === 1000);
        
        for ( i = 0 ; i < 1000 ; i++ ) {
            map = map.remove(i,i);
        } 
        ok(map.size() === 0);
    });

});
