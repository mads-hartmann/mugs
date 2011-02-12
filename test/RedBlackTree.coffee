RedBlackTreeWrapper = require('../src/RedBlackTree')
RedBlackTree        = RedBlackTreeWrapper.RedBlackTree
Leaf                = RedBlackTreeWrapper.Leaf
RED                 = RedBlackTreeWrapper.RED
BLACK               = RedBlackTreeWrapper.BLACK

# tree = new RedBlackTree(RED, Leaf, 5, Leaf)
# console.log tree

( () -> 
  tree = new RedBlackTree(RED, Leaf, 5, Leaf)
  ok tree.contains(5)
  ok !tree.contains(2)
)()


( () -> 
  ###
    Tests that the balancing works in the case where two left nodes are red.
  ###
  
  e1 = 5
  e2 = 4
  e3 = 3
  
  tree = new RedBlackTree(RED, Leaf, e1, Leaf)
  tree2 = tree.insert(e2).insert(e3)
  
  # Check that no elements went missing
  ok tree2.contains(e1)
  ok tree2.contains(e2)
  ok tree2.contains(e3)
  
  # Check the structure
  { 
  , left:
     {
     , element: x3
     }
  , element: x2
  , right: 
     {
     , element: x1
     }
  , comparator: [Function]
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
  
  tree = new RedBlackTree(RED, Leaf, e1, Leaf)
  tree2 = tree.insert(e3).insert(e2)
  
  # Check that no elements went missing
  ok tree2.contains(e1)
  ok tree2.contains(e2)
  ok tree2.contains(e3)
  
  { 
  , left: 
     { 
     , left: {}
     , element: x3
     }
  , element: x2
  , right: 
     { 
     , element: x1
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
  
  tree = new RedBlackTree(RED, Leaf, e1, Leaf)
  tree2 = tree.insert(e2).insert(e3)
  
  # Check that no elements went missing
  ok tree2.contains(e1)
  ok tree2.contains(e2)
  ok tree2.contains(e3) 
  
  { 
  , left: 
     { 
     , left: {}
     , element: x1
     }
  , element: x2
  , right: 
     { 
     , element: x3
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
  
  tree = new RedBlackTree(RED, Leaf, e1, Leaf)
  tree2 = tree.insert(e2).insert(e3)
  
  # Check that no elements went missing
  ok tree2.contains(e1)
  ok tree2.contains(e2)
  ok tree2.contains(e3)

  { 
  , left: 
     { 
     , left: {}
     , element: x1
     }
  , element: x3
  , right: 
     { 
     , element: x2
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
  
  tree = new RedBlackTree(RED, Leaf, e1, Leaf)
  tree2 = tree.insert(e2).insert(e3)
  
  # Check that no elements went missing
  ok tree2.contains(e1)
  ok tree2.contains(e2)
  ok tree2.contains(e3)

  { 
  , left: 
     { 
     , left: {}
     , element: x3
     }
  , element: x1
  , right: 
     { 
     , element: x2
     }
  } = tree2
  
  ok x1 == e1
  ok x2 == e2
  ok x3 == e3
)()

( () -> 
  ###
    Tests that it can find the maximum and minimum element 
  ### 
  tree = new RedBlackTree(RED, Leaf, 5, Leaf).insert(6)
  max = tree.max()
  min = tree.min()
  ok max == 6
  ok min == 5
)()


( () -> 
  # Testing that it can remove an element. This doesn't test that the 
  # invariants are still true.
  tree  = new RedBlackTree(RED, Leaf, 5, Leaf).insert(6)
  ok tree.contains(6)
  ok !tree.remove(6).contains(6)
)()

( () -> 
  tree  = new RedBlackTree(RED, Leaf, 7, Leaf).insert(5).insert(8).insert(3).insert(6)
  
  ok tree.contains(8)
  ok tree.contains(7)
  ok tree.contains(6)
  ok tree.contains(5)
  ok tree.contains(3)
  ## removal of internal node
  tree2 = tree.remove(5)
  ok tree2.contains(8)
  ok tree2.contains(7)
  ok tree2.contains(6)
  ok !tree2.contains(5)
  ok tree2.contains(3)
  
  { 
  , left: 
     { 
     , left: {}
     , element: x1      #3
     , right: {}
     }
  , element: x2         #6
  , right: 
     { 
     , left: {}
     , element: x3      #7
     , right: 
        { 
        , left: {}
        , element: x4   #8
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
  
  ok !tree3.contains(8)
  ok tree3.contains(7)
  ok tree3.contains(6)
  ok !tree3.contains(5)
  ok tree3.contains(3)
  
  { 
  , left: 
     {
     , left: {}
     , element: y1
     , right: {}
     }
  , element: y2
  , right: 
     { 
     , left: {}
     , element: y3
     , right: {}
     }
  } = tree3
  
  ok y1 == 3
  ok y2 == 6
  ok y3 == 7
  
  ## removal: isNodeWithOneChildLeft
  tree4 = new RedBlackTree(RED, Leaf, 7, Leaf).insert(4).insert(3).insert(2).remove(3)
  
  ok tree4.contains(7)
  ok tree4.contains(4)
  ok tree4.contains(2)
  ok !tree4.contains(3)
  
  { 
  , left: 
     { 
     , left: {}
     , element: z1
     , right: {}
     }
  , element: z2
  , right: 
     { 
     , left: {}
     , element: z3
     , right: {}
     }
  } = tree4
  
  ok z1 == 2
  ok z2 == 4
  ok z3 == 7
  
  ##removal: isNodeWithOneChildRight
  tree5 = new RedBlackTree(RED, Leaf, 7, Leaf).insert(4).insert(3).insert(8).remove(8)

  ok tree5.contains(7)
  ok tree5.contains(4)
  ok tree5.contains(3)
  ok !tree5.contains(8)

  { 
  , left: 
     { 
     , left: {}
     , element: q1
     , right: {}
     }
  , element: q2
  , right: 
     { 
     , left: {}
     , element: q3
     , right: {}
     }
  } = tree5

  ok q1 == 3
  ok q2 == 4
  ok q3 == 7

  ## Get a left negative black balance
  
  ## get a right negative black balance
)()