$(document).ready(function(){
  
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
  
  test("It is possible to lookup an element", function() {
    var node = new CompleteBinaryTreeNode(1, new CompleteBinaryTreeLeaf(2), new CompleteBinaryTreeLeaf(3));
    ok(node.lookup(0) == 1);
    ok(node.lookup(1) == 2);
    ok(node.lookup(2) == 3);
  });
  
  test("It is possible to create a update an element", function() {
    var node = new CompleteBinaryTreeNode(1, new CompleteBinaryTreeLeaf(2), new CompleteBinaryTreeLeaf(3));
    node = node.update(0,10);
    ok(node.lookup(0) == 10);
  });
  
});