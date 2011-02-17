RedBlackNodeWrapper = require('../src/RedBlackTree')
RedBlackNode        = RedBlackNodeWrapper.RedBlackNode
RedBlackLeaf        = RedBlackNodeWrapper.Leaf
RED                 = RedBlackNodeWrapper.RED
BLACK               = RedBlackNodeWrapper.BLACK

# tree = new RedBlackNode(RED, Leaf, 5, Leaf)
# console.log tree

( () -> 
  tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), 5,5, new RedBlackLeaf(BLACK))
  ok tree.containsKey(5)
  ok !tree.containsKey(2)
)()


( () -> 
  ###
    Tests that the balancing works in the case where two left nodes are red.
  ###
  
  e1 = 5
  e2 = 4
  e3 = 3
  
  tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), e1, e1, new RedBlackLeaf(BLACK))
  tree2 = tree.insert(e2).insert(e3)
  
  # Check that no keys went missing
  ok tree2.containsKey(e1)
  ok tree2.containsKey(e2)
  ok tree2.containsKey(e3)
  
  # Check the structure
  { 
  , left:
     {
     , key: x3
     }
  , key: x2
  , right: 
     {
     , key: x1
     }
  } = tree2
        
  ok (x1 == e1)
  ok (x2 == e2)
  ok (x3 == e3)
  
)()

( () -> 
  ###
    Tests that the balancing works in the case where left and left.right nodes are red.
  ###
  
  e1 = 5
  e2 = 4
  e3 = 3
  
  tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), e1, e1, new RedBlackLeaf(BLACK))
  tree2 = tree.insert(e3).insert(e2)
  
  # Check that no keys went missing
  ok tree2.containsKey(e1)
  ok tree2.containsKey(e2)
  ok tree2.containsKey(e3)
  
  { 
  , left: 
     { 
     , left: {}
     , key: x3
     }
  , key: x2
  , right: 
     { 
     , key: x1
     }
  } = tree2
  
  ok (x1 == e1)
  ok (x2 == e2)
  ok (x3 == e3)
)()


( () -> 
  ###
    Tests that the balancing works in the case where two right nodes in a row are red 
  ###
  
  e1 = 5
  e2 = 6
  e3 = 7
  
  tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), e1, e1, new RedBlackLeaf(BLACK))
  tree2 = tree.insert(e2).insert(e3)
  
  # Check that no keys went missing
  ok tree2.containsKey(e1)
  ok tree2.containsKey(e2)
  ok tree2.containsKey(e3) 
  
  { 
  , left: 
     { 
     , left: {}
     , key: x1
     }
  , key: x2
  , right: 
     { 
     , key: x3
     }
  } = tree2
  
  ok (x1 == e1)
  ok (x2 == e2)
  ok (x3 == e3)
)()

( () -> 
  ###
    Tests that the balancing works in the case where a right node followed by a left node are red
  ###
  
  e1 = 5
  e2 = 7
  e3 = 6
  
  tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), e1,e1, new RedBlackLeaf(BLACK))
  tree2 = tree.insert(e2).insert(e3)
  
  # Check that no keys went missing
  ok tree2.containsKey(e1)
  ok tree2.containsKey(e2)
  ok tree2.containsKey(e3)

  { 
  , left: 
     { 
     , left: {}
     , key: x1
     }
  , key: x3
  , right: 
     { 
     , key: x2
     }
  } = tree2
  
  ok x1 == e1
  ok x2 == e2
  ok x3 == e3
)()

( () -> 
  ###
    Test that it doesn't try to balance the tree if it isn't needed
  ###
  
  e1 = 6
  e2 = 7
  e3 = 5
  
  tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), e1,e1, new RedBlackLeaf(BLACK))
  tree2 = tree.insert(e2).insert(e3)
  
  # Check that no keys went missing
  ok tree2.containsKey(e1)
  ok tree2.containsKey(e2)
  ok tree2.containsKey(e3)

  { 
  , left: 
     { 
     , left: {}
     , key: x3
     }
  , key: x1
  , right: 
     { 
     , key: x2
     }
  } = tree2
  
  ok x1 == e1
  ok x2 == e2
  ok x3 == e3
)()

( () -> 
  ###
    Tests that it can find the maximum and minimum key 
  ### 
  tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), 5,5, new RedBlackLeaf(BLACK)).insert(6)
  max = tree.maxKey()
  min = tree.minKey()
  ok max == 6
  ok min == 5
)()


( () -> 
  # Testing that it can remove an key. This doesn't test that the 
  # invariants are still true.
  tree  = new RedBlackNode(RED, new RedBlackLeaf(BLACK), 5,5, new RedBlackLeaf(BLACK)).insert(6)
  ok tree.containsKey(6)
  ok !tree.remove(6).containsKey(6)
)()
 
( () -> 
  tree  = new RedBlackNode(RED, new RedBlackLeaf(BLACK), 7,7, new RedBlackLeaf(BLACK)).insert(5).insert(8).insert(3).insert(6)
  
  ok tree.containsKey(8)
  ok tree.containsKey(7)
  ok tree.containsKey(6)
  ok tree.containsKey(5)
  ok tree.containsKey(3)
  ## removal of internal node
  tree2 = tree.remove(5)
  ok tree2.containsKey(8)
  ok tree2.containsKey(7)
  ok tree2.containsKey(6)
  ok !tree2.containsKey(5)
  ok tree2.containsKey(3)
  
  { 
  , left: 
     { 
     , left: {}
     , key: x1      #3
     , right: {}
     }
  , key: x2         #6
  , right: 
     { 
     , left: {}
     , key: x3      #7
     , right: 
        { 
        , left: {}
        , key: x4   #8
        , right: {}
        }
     }
  } = tree2
  
  ok (x1 == 3)
  ok (x2 == 6)
  ok (x3 == 7)
  ok (x4 == 8)
  
  ## removal of external node
  tree3 = tree2.remove(8)
  
  ok !tree3.containsKey(8)
  ok tree3.containsKey(7)
  ok tree3.containsKey(6)
  ok !tree3.containsKey(5)
  ok tree3.containsKey(3)
  
  { 
  , left: 
     {
     , left: {}
     , key: y1
     , right: {}
     }
  , key: y2
  , right: 
     { 
     , left: {}
     , key: y3
     , right: {}
     }
  } = tree3
  
  ok y1 == 3
  ok y2 == 6
  ok y3 == 7
  
  ## removal: isNodeWithOneChildLeft
  tree4 = new RedBlackNode(RED, new RedBlackLeaf(BLACK), 7, 7, new RedBlackLeaf(BLACK)).insert(4).insert(3).insert(2).remove(3)
  
  ok tree4.containsKey(7)
  ok tree4.containsKey(4)
  ok tree4.containsKey(2)
  ok !tree4.containsKey(3)
  
  { 
  , left: 
     { 
     , left: {}
     , key: z1
     , right: {}
     }
  , key: z2
  , right: 
     { 
     , left: {}
     , key: z3
     , right: {}
     }
  } = tree4
  
  ok z1 == 2
  ok z2 == 4
  ok z3 == 7
  
  ##removal: isNodeWithOneChildRight
  tree5 = new RedBlackNode(RED, new RedBlackLeaf(BLACK), 7,7, new RedBlackLeaf(BLACK)).insert(4).insert(3).insert(8).remove(8)
  
  ok tree5.containsKey(7)
  ok tree5.containsKey(4)
  ok tree5.containsKey(3)
  ok !tree5.containsKey(8)
  
  { 
  , left: 
     { 
     , left: {}
     , key: q1
     , right: {}
     }
  , key: q2
  , right: 
     { 
     , left: {}
     , key: q3
     , right: {}
     }
  } = tree5
  
  ok q1 == 3
  ok q2 == 4
  ok q3 == 7
  
  ## Get a left negative black balance
  
  ## get a right negative black balance
)()