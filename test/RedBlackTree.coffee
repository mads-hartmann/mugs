RedBlackTreeWrapper = require('../src/RedBlackTree')
RedBlackTree        = RedBlackTreeWrapper.RedBlackTree
Leaf                = RedBlackTreeWrapper.Leaf
RED                 = RedBlackTreeWrapper.RED
BLACK               = RedBlackTreeWrapper.BLACK

# tree = new RedBlackTree(RED, Leaf, 5, Leaf)
# console.log tree

( () -> 
  tree = new RedBlackTree(RED, Leaf, 5, Leaf)
  ok tree.contains(5) is true
  ok tree.contains(2) is false 
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
  ok tree2.contains(e1) is true
  ok tree2.contains(e2) is true
  ok tree2.contains(e3) is true
  
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
    
  ok (x1 == e1) is true
  ok (x2 == e2) is true
  ok (x3 == e3) is true
  
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
  ok tree2.contains(e1) is true
  ok tree2.contains(e2) is true
  ok tree2.contains(e3) is true
  
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
  
  ok (x1 == e1) is true
  ok (x2 == e2) is true
  ok (x3 == e3) is true
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
  ok tree2.contains(e1) is true
  ok tree2.contains(e2) is true
  ok tree2.contains(e3) is true
  
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
  
  ok (x1 == e1) is true
  ok (x2 == e2) is true
  ok (x3 == e3) is true
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
  ok tree2.contains(e1) is true
  ok tree2.contains(e2) is true
  ok tree2.contains(e3) is true

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
  
  ok (x1 == e1) is true
  ok (x2 == e2) is true
  ok (x3 == e3) is true
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
  ok tree2.contains(e1) is true
  ok tree2.contains(e2) is true
  ok tree2.contains(e3) is true

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
  
  ok (x1 == e1) is true
  ok (x2 == e2) is true
  ok (x3 == e3) is true
)()