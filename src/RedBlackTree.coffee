#### Description

# A Red-black tree is a binary tree with two invariants that ensure
# that the tree is balanaced to keep the height of the tree low.
#
# 1. No red node has a red child
# 2. Every path from the root to an empty node contains 
#    the same number of black nodes
#
# The insert and contains methods have been implemented following Chris ...
# book 'purely functional data structures' and the remove operations has been
# implemented following this blog: http://matt.might.net/articles/red-black-delete/


#### Operations 
# <table>
#   <tr>
#     <td>Name</td>
#     <td>Complexity</td>
#   </tr>
#   <tr>
#     <td> contains(element) </td>
#     <td> O(log n) </td>
#   </tr>  
#   <tr>
#     <td> insert(element) </td>
#     <td> O(log n) </td>
#   </tr>
#   <tr>
#     <td> remove(element) TODO </td>
#     <td> O(log n) </td>
#   </tr>
# </table>

#### Implementation

# Importing dependencies
if require?
  Option   = require './option'
  Some     = Option.Some
  None     = Option.None

# Constants used to color the trees. The proprty 'color' is only for debugging.
RED = { 
  color: "RED",  
  add: () -> BLACK ,
  subtract: () -> NEGATIVE_BLACK
}  
BLACK = { 
  color: "BLACK",  
  add: () -> DOUBLE_BLACK,
  subtract: () -> RED
}
DOUBLE_BLACK = { 
  color: "DOUBLE BLACK",
  add: () -> DOUBLE_BLACK,
  subtract: () -> BLACK
}
NEGATIVE_BLACK = { 
  color: "NEGATIVE BLACK"
  add: () -> RED
  subtract: () -> NEGATIVE_BLACK
}

# The empty node (i.e. Leaf) in a Red-Black tree. We only ever need one instance
# so this isn't implemented as a class.
Leaf = {
  left: new None(),
  right: new None(),
  element: new None(),
  color: BLACK,
  isEmpty: () -> true
}

class NLeaf 
  
  constructor: (color) -> 
    this.color   = color 
    this.left    = new None()
    this.right   = new None()
    this.element = new None()
  
  isEmpty: () -> true 


# The RedBlackTree class
class RedBlackTree 
  # The standard compare function. It's used if the user doesn't 
  # supply one when creating the tree
  STANDARD_COMPARATOR = (elem1, elem2) -> 
    if      (elem1 < elem2) then -1
    else if (elem1 > elem2) then  1
    else                          0
  
  # The properties of the RedBlackTree
  this.color 
  this.left
  this.element
  this.right
  this.comparator
  
  # Constructor to create new instance of RedBlackTree.
  # The comparator argument is optional. 
  constructor: (color, left, element, right, comparator) -> 
    this.color      = color
    this.left       = left
    this.element    = element
    this.right      = right 
    this.comparator = if (comparator) then  else STANDARD_COMPARATOR
  
  # Finds the smallest element in the tree 
  # Complexity of O ( log n )
  min: () -> 
    if (this.left.isEmpty()) then this.element else this.left.element()

  # Finds the largest element in the tree 
  # Complexity of O ( log n )
  max: () ->     
    if (this.right.isEmpty()) then this.element else this.right.max()
  
  # Checks if the given element exists in the tree
  contains: (element) -> 
    __contains = (tree) => 
      {left: l, element: e, right: r} = tree
      compare = this.comparator(element,e)
      
      if      (tree.isEmpty()) then  false
      else if (compare < 0)    then  __contains(l)
      else if (compare > 0)    then  __contains(r)
      else                           true
    __contains(this)
  
  # Returns a new tree with the inserted element.
  insert: (element) -> 
    __insert = (tree) => 
      {color: c, left: l, element: e, right: r} = tree
      compare = this.comparator(element, e)
      
      if (tree.isEmpty()) 
        new RedBlackTree(RED, Leaf, element, Leaf)
      else if (compare < 0) 
        balance(c, __insert(l), e, r)
      else if (compare > 0)
        balance(c, l, e, __insert(r))
      else
        tree
      
    t = __insert(this)
    new RedBlackTree(BLACK, t.left, t.element, t.right)
  
  # Returns a new tree without the 'element'
  # Port from this racket example: http://matt.might.net/articles/red-black-delete/
  remove: (element) -> 
    __rm = (tree) => 
      isExternalNode          = () -> tree.left.isEmpty() && tree.right.isEmpty() 
      isInternalNode          = () -> !tree.left.isEmpty() && !tree.right.isEmpty()
      isNodeWithOneChildLeft  = () -> (tree.color == BLACK) && 
                                      (tree.left.color == RED && tree.right.isEmpty() )
      isNodeWithOneChildRight = () -> (tree.color == BLACK) &&
                                      (tree.right.color == RED && tree.left.isEmpty())
      # The __rm call traversed all the way to the bottom of the tree. This happens
      # when the item to remove wasn't in the tree.
      if ( tree.isEmpty() )
        tree
      # Removing an external node 
      else if (isExternalNode()) 
       if (tree.color == RED)
         new NLeaf(BLACK)
       else if (tree.color == BLACK)
         new NLeaf(DOUBLE_BLACK)
     
      # Removing a node with one child 
      else if (isNodeWithOneChildLeft()) # I can probably use the option here (i.e.) this.right.getOrElse(this.left.getOrElse())
        new RedBlackTree( BLACK, tree.left.left, tree.left.element, tree.left.right)
      else if (isNodeWithOneChildRight())
        new RedBlackTree( BLACK, tree.right.left, tree.right.element, tree.right.right)
    
      # Removing an internal node 
      else if (isInternalNode())
        # Convert a removal of an internal noe to a node with a most one child. 
        # Find the largest element in the left subtree, use that value for the new tree
        # and remove the other node
        max         = tree.left.max()
        newLeftTree = tree.left.remove(max)
        bubble( tree.color, newLeftTree, max, tree.right)
      else
        new RedBlackTree(tree.color, tree.left, tree.element, tree.right)
    # Search for the subtree to remove the element from. Keep the references
    # to the tree that don't contain the element. I.e. if the element we're looking
    # for is in the right subtree we can just reuse the reference to the left subtree
    # in the new tree we're creating.
    compare = this.comparator(element, this.element)
    if (compare < 0)
      new RedBlackTree(this.color, this.left.remove(element), this.element, this.right)
    else if (compare > 0)
      new RedBlackTree(this.color, this.left, this.element, this.right.remove(element))
    else 
      __rm(this)
  
  # The bubble procedure moves double-blacks from children to parents, 
  # or eliminates them entirely if possible.
  # A black is substracted from the children, and added to the parent:
  bubble = (color, left, element, right) -> 
    if ( left.color == DOUBLE_BLACK || right.color == DOUBLE_BLACK)
      balance( 
        color.add(), 
        new RedBlackTree(left.color.subtract(), left.left, left.element, left.right),
        element, 
        new RedBlackTree(right.color.subtract(), right.left, right.element, right.right))
    else 
      new RedBlackTree(color, left, element, right)
      
  # This function balances the tree by eliminating any black-red-red path in the tree.
  # This situation can occur in any of four configurations:
  #                                                                                   
  # Reading the nodes from top to bottom:                                              
  # 
  # 1. red left node followed by a red left node                                        
  # 2. red left node followed by a red right node                                       
  # 3. red right node followed by a red right node                                      
  # 4. red right node followed by a red left node                                       
  #                                                                                   
  # The solution is always the same: Rewrite the black-red-red path as a red node with
  # two black children.                                                                
  balance = (color, left, element, right) ->
    
    leftFollowedByLeft = () -> 
      (!left.isEmpty() && !left.left.isEmpty()) && 
      (color == BLACK || color == DOUBLE_BLACK) and left.color == RED and left.left.color == RED
      
    leftFollowedByRight = () -> 
      (!left.isEmpty() && !left.right.isEmpty()) && 
      (color == BLACK || color == DOUBLE_BLACK) and left.color == RED and left.right.color == RED
      
    rightFollowedByLeft = () ->
      (!right.isEmpty() && !right.left.isEmpty()) && 
      (color == BLACK || color == DOUBLE_BLACK) && right.color == RED && right.left.color  == RED
      
    rightFollowedByRight = () -> 
      (!right.isEmpty() && !right.right.isEmpty()) && 
      (color == BLACK || color == DOUBLE_BLACK) && right.color == RED && right.right.color == RED
    
    leftIsNegativeBlack = () -> 
      (!left.isEmpty()) && left.color == NEGATIVE_BLACK
    
    rightIsNegativeBlack = () -> 
      (!right.isEmpty()) && right.color == NEGATIVE_BLACK
      
    if (leftFollowedByLeft())
      new RedBlackTree(color.subtract(), # The root color is subtracted. This takes care of double black
        new RedBlackTree(BLACK,left.left.left,left.left.element,left.left.right), 
        left.element, 
        new RedBlackTree(BLACK,left.right,element,right)) 
    else if (leftFollowedByRight())
      new RedBlackTree(color.subtract(), 
        new RedBlackTree(BLACK,left.left,left.element,left.right.left), 
        left.right.element, 
        new RedBlackTree(BLACK,right.right.right,element,right)) 
    else if (rightFollowedByLeft())
      new RedBlackTree(color.subtract(), 
        new RedBlackTree(BLACK,left,element,right.left.left), 
        right.left.element, 
        new RedBlackTree(BLACK,right.left.right,right.element,right.right)) 
    else if (rightFollowedByRight())
      new RedBlackTree(color.subtract(), 
        new RedBlackTree(BLACK,left,element,right.left), 
        right.element, 
        new RedBlackTree(BLACK,right.right.left,right.right.element,right.right.right)) 
    else if (leftIsNegativeBlack())
      new RedBlackTree(BLACK,
        new RedBlackTree(BLACK,
          balance( RED,left.left.left, left.left.element, left.left.right ),
          left.element,
          left.right.left
        ),
        left.right.element
        new RedBlackTree(BLACK,right.left.right, element, right)
      )
    else if (rightIsNegativeBlack())
      new RedBlackTree(
        BLACK,
        new RedBlackTree(
          BLACK,
          left,
          right.element,         
          right.left.left
        ),
        right.right.element,     
        new RedBlackTree(
          BLACK,
          right.left.right,
          element,               
          balance( RED, right.right.left, right.left.element, right.right.right )
        )
      )
    else
      new RedBlackTree(color, left, element, right)
  
  isEmpty: () -> false

# Exporing objects if people are using this as a node module
if exports?
  exports.Leaf = Leaf
  exports.RedBlackTree = RedBlackTree
  exports.RED = RED
  exports.BLACK = BLACK