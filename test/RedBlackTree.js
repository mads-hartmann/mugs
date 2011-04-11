$(document).ready(function(){

  RedBlackTree = mugs.RedBlackTree;
  RedBlackNode = mugs.RedBlackNode;
  RedBlackLeaf = mugs.RedBlackLeaf;
  
  module("RedBlackTree");
  
  test("It's possible to construct a tree with one key-value pair", function() {
    var tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), 5,5, new RedBlackLeaf(BLACK));    
    ok(tree.containsKey(5));
    ok(!tree.containsKey(2));
  });
  
  test("Tests that the balancing works in the case where two left nodes are red.",function() {
    var e1 = 5,
        e2 = 4,
        e3 = 3;

    var tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), e1, e1, new RedBlackLeaf(BLACK)).insert(e2).insert(e3);

    ok(tree.containsKey(e1) && tree.containsKey(e2) && tree.containsKey(e3),
      "Contains all the right keys");

    ok(tree.key == e2 &&
       tree.left.key == e3 && 
       tree.right.key == e1,
       "The position of the keys are correct");
  });
  
  test("Tests that the balancing works in the case where left and left.right nodes are red.", function() {
    
    var e1 = 5,
        e2 = 4,
        e3 = 3;

    var tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), e1, e1, new RedBlackLeaf(BLACK)).insert(e3).insert(e2);

    ok(tree.containsKey(e1) && tree.containsKey(e2) && tree.containsKey(e3),
      "Contains all the right keys");

    ok(tree.key == e2 &&
       tree.left.key == e3 &&
       tree.right.key == e1,
       "The position of the keys are correct");
  });
  
  test("Tests that the balancing works in the case where two right nodes in a row are red ", function() {
    var e1 = 5,
        e2 = 6,
        e3 = 7;

    var tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), e1, e1, new RedBlackLeaf(BLACK)).insert(e3).insert(e2);

    ok(tree.containsKey(e1) && tree.containsKey(e2) && tree.containsKey(e3),
      "Contains all the right keys");

    ok(tree.key == e2 &&
       tree.left.key == e1 &&
       tree.right.key == e3,
       "The position of the keys are correct");
  });
  
  test("Tests that the balancing works in the case where a right node followed by a left node are red", function() {
    var e1 = 5,
        e2 = 7,
        e3 = 6;

    var tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), e1, e1, new RedBlackLeaf(BLACK)).insert(e3).insert(e2);

    ok(tree.containsKey(e1) && tree.containsKey(e2) && tree.containsKey(e3),
      "Contains all the right keys");

    ok(tree.key == e3 &&
       tree.left.key == e1 &&
       tree.right.key == e2,
       "The position of the keys are correct");
  });
  
  test("Test that it doesn't try to balance the tree if it isn't needed", function() {
    var e1 = 6,
        e2 = 7,
        e3 = 5;

    var tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), e1, e1, new RedBlackLeaf(BLACK)).insert(e3).insert(e2);

    ok(tree.containsKey(e1) && tree.containsKey(e2) && tree.containsKey(e3),
      "Contains all the right keys");

    ok(tree.key == e1 &&
       tree.left.key == e3 &&
       tree.right.key == e2,
       "The position of the keys are correct");
  });
  
  test("Tests that it can find the maximum and minimum key ",function() {
    var tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), 5,5, new RedBlackLeaf(BLACK)).insert(6,6).insert(90,90).insert(1,1);
    var max = tree.maxKey();
    var min = tree.minKey();
    ok(max == 90, "Max key is 90");
    ok(min == 1, "Min key is 1");
  });
  
  test("Test that it's possible to remove a key-value pair.", function() {
    var tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), 5,5, new RedBlackLeaf(BLACK)).insert(6);
    ok(tree.containsKey(6));
    ok(!tree.remove(6).containsKey(6));
  });
  
  test("Test removal of internal node", function() {
    var tree  = new RedBlackNode(RED, new RedBlackLeaf(BLACK), 7,7, new RedBlackLeaf(BLACK)).insert(5).insert(8).insert(3).insert(6);
    
    ok(tree.containsKey(8));
    ok(tree.containsKey(7));
    ok(tree.containsKey(6));
    ok(tree.containsKey(5));
    ok(tree.containsKey(3));
    
    var tree2 = tree.remove(5);
    ok(tree2.containsKey(8));
    ok(tree2.containsKey(7));
    ok(tree2.containsKey(6));
    ok(!tree2.containsKey(5));
    ok(tree2.containsKey(3));
    
    ok (tree2.left.key == 3);
    ok (tree2.key == 6);
    ok (tree2.right.key == 7);
    ok (tree2.right.right.key == 8);
  });
  
  test("Test removal of external node", function() {
    var tree  = new RedBlackNode(RED, new RedBlackLeaf(BLACK), 7,7, new RedBlackLeaf(BLACK)).insert(5).insert(8).insert(3).insert(6).remove(5).remove(8);
    ok(!tree.containsKey(8));
    ok(tree.containsKey(7));
    ok(tree.containsKey(6));
    ok(!tree.containsKey(5));
    ok(tree.containsKey(3));

    ok(tree.left.key == 3);
    ok(tree.key == 6);
    ok(tree.right.key == 7);
    
  });
  
  test("Removal of node with one left child", function() {
    var tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), 7, 7, new RedBlackLeaf(BLACK)).insert(4).insert(3).insert(2).remove(3);

    ok(tree.containsKey(7));
    ok(tree.containsKey(4));
    ok(tree.containsKey(2));
    ok(!tree.containsKey(3));


    ok(tree.left.key == 2);
    ok(tree.key == 4);
    ok(tree.right.key == 7);
  });
  
  test("Removal of node with one right child", function() {
    var tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), 7,7, new RedBlackLeaf(BLACK)).insert(4).insert(3).insert(8).remove(8);

    ok(tree.containsKey(7));
    ok(tree.containsKey(4));
    ok(tree.containsKey(3));
    ok(!tree.containsKey(8));

    ok(tree.left.key == 3);
    ok(tree.key == 4);
    ok(tree.right.key == 7);
  });
  
  test("Balance a left negative black node", function() {
    
  });
  
  test("Balance a right negative black node", function() {
    
  });
  
});