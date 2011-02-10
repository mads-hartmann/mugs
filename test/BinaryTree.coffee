BinaryTreeWrapper = require('../src/BinaryTree')
BinaryTree        = BinaryTreeWrapper.BinaryTree
Leaf              = BinaryTreeWrapper.Leaf


( () -> 
  tree = new BinaryTree(Leaf, 5, Leaf)
  ok tree.contains(5) is true
  ok tree.contains(2) is false 
)()

( () -> 
  tree = new BinaryTree(new BinaryTree(Leaf, 2, Leaf), 5, Leaf)
  ok tree.contains(2) is true
)()


( () -> 
  ###
    Test that insertion works and that it doesn't destroy the 
    original tree. Also, this shows that the tree is very
    unbalanced. 
  ###
  tree = new BinaryTree(Leaf, 5, Leaf)
  tree2 = tree.insert(4).insert(3).insert(2)  
  
  # This part tests that the new tree has the right structure 
  { left: 
     { left: 
        { left: 
          { left: {}
          , element: x4
          }
        , element: x3
        }
     , element: x2
     }
  , element: x1
  } = tree2
  
  
  ok (x4 == 2) is true
  ok (x3 == 3) is true
  ok (x2 == 4) is true
  ok (x1 == 5) is true 
  
  # This part tests that the orignial tree hasn't been destroyed
   
  { left: {}
  , element: y1
  , right: {}
  , comparator: [Function]
  } = tree
   
  ok (y1 == 5) is true
  ok (right.isEmpty()) is true
  ok (left.isEmpty()) is true
)()



