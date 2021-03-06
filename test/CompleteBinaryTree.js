$(document).ready(function(){

  CompleteBinaryTreeNode = mugs.CompleteBinaryTreeNode;
  CompleteBinaryTreeLeaf = mugs.CompleteBinaryTreeLeaf;
  
  module("Complete Binary Tree");
  
  test("It is possible to create a node", function() {
    var node = new CompleteBinaryTreeNode(1, new CompleteBinaryTreeLeaf(2), new CompleteBinaryTreeLeaf(3));
    ok(node.item == 1);
    ok(!node.isLeaf);
    ok(node.left.item == 2);
    ok(node.right.item == 3);
  });
  
  test("It is possible to create a leaf", function() {
    var leaf = new CompleteBinaryTreeLeaf(1);
    ok(leaf.item == 1);
    ok(leaf.isLeaf);
  });
  
  test("It is possible to get an element (3)", function() {
    var node = new CompleteBinaryTreeNode(1, new CompleteBinaryTreeLeaf(2), new CompleteBinaryTreeLeaf(3));
    ok(node.get(0) == 1);
    ok(node.get(1) == 2);
    ok(node.get(2) == 3);
  });
  
  test("get (too large index)", function() {
     var node = new CompleteBinaryTreeNode(1, new CompleteBinaryTreeLeaf(2), new CompleteBinaryTreeLeaf(3));
     rslt = false;
    try{
        node.get(10);
    }catch(e){
        rslt = true;
    }
    ok(rslt);
  });
  
  test("update (too large index)", function() {
      var node = new CompleteBinaryTreeNode(1, new CompleteBinaryTreeLeaf(2), new CompleteBinaryTreeLeaf(3));
      rslt = false;
      try{
          node.update(10,10);
      } catch(e) {
          rslt = true;
      }
      ok(rslt);
});
  
  test("get (negative index)", function() {
       var node = new CompleteBinaryTreeNode(1, new CompleteBinaryTreeLeaf(2), new CompleteBinaryTreeLeaf(3));
       rslt = false;
       try{
           node.get(-1);
       }catch(e){
           rslt = true;
       }
       ok(rslt);
    });
  
  test("It is possible to get an element (7)", function() {
    var node = new CompleteBinaryTreeNode(1, 
      new CompleteBinaryTreeNode(2,
        new CompleteBinaryTreeLeaf(3), 
        new CompleteBinaryTreeLeaf(4)
      ),
      new CompleteBinaryTreeNode(5,
        new CompleteBinaryTreeLeaf(6), 
        new CompleteBinaryTreeLeaf(7)
      )
    );
    ok(node.get(0) == 1);
    ok(node.get(1) == 2);
    ok(node.get(2) == 3);
    ok(node.get(3) == 4);
    ok(node.get(4) == 5);
    ok(node.get(5) == 6);
    ok(node.get(6) == 7);
  });
  
  test("It is possible to update an element", function() {
    var node = new CompleteBinaryTreeNode(1, new CompleteBinaryTreeLeaf(2), new CompleteBinaryTreeLeaf(3));
    node = node.update(0,10);
    ok(node.get(0) == 10);
  });
  
  test("It is possible to update an element (7)", function() {
    var node = new CompleteBinaryTreeNode(1, 
      new CompleteBinaryTreeNode(2,
        new CompleteBinaryTreeLeaf(3), 
        new CompleteBinaryTreeLeaf(4)
      ),
      new CompleteBinaryTreeNode(5,
        new CompleteBinaryTreeLeaf(6), 
        new CompleteBinaryTreeLeaf(7)
      )
    );
    updated = node.update(0,7)
                  .update(1,6)
                  .update(2,5)
                  .update(3,4)
                  .update(4,3)
                  .update(5,2)
                  .update(6,1);
    ok(updated.get(0) == 7);
    ok(updated.get(1) == 6);
    ok(updated.get(2) == 5);
    ok(updated.get(3) == 4);
    ok(updated.get(4) == 3);
    ok(updated.get(5) == 2);
    ok(updated.get(6) == 1);
  });
  
});