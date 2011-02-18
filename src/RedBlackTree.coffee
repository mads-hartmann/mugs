# Importing dependencies
if require?
  Option   = require './option'
  Some     = Option.Some
  None     = Option.None
  List     = require('./list').List
  Cons     = require('./list').Cons
  Nil      = require('./list').Nil

# Constants used to color the trees. The proprty 'color' is only for debugging.
RED = { 
  color:      "RED",  
  add:        () -> BLACK ,
  subtract:   () -> NEGATIVE_BLACK
}  
BLACK = { 
  color:      "BLACK",  
  add:        () -> DOUBLE_BLACK,
  subtract:   () -> RED
}
DOUBLE_BLACK = { 
  color:      "DOUBLE BLACK",
  add:        () -> DOUBLE_BLACK,
  subtract:   () -> BLACK
}
NEGATIVE_BLACK = { 
  color:      "NEGATIVE BLACK"
  add:        () -> RED
  subtract:   () -> NEGATIVE_BLACK
}

###*
  @class An empty tree ( a leaf )
###
class RedBlackLeaf 
  
  constructor: (color) -> 
    this.color   = color 
    this.left    = new None()
    this.right   = new None()
    this.key     = new None()
    this.value   = new None()
  
  isEmpty:      ()      -> true 
  containsKey:  (key)   -> false
  get:          (key)   -> new None()
  keys:         ()      -> new Nil() 
  values:       ()      -> new Nil() 
  inorderMap:   (func)  -> new Nil()


###*
  @class 
  A Red-black tree is a binary tree with two invariants that ensure
  that the tree is balanced to keep the height of the tree low.
  
  1. No red node has a red child
  2. Every path from the root to an empty node contains 
     the same number of black nodes
  
  The insert and contains methods have been implemented following Chris ...
  book 'purely functional data structures' and the remove operations has been
  implemented following this blog: http://matt.might.net/articles/red-black-delete/
###
class RedBlackNode 
  # The standard compare function. It's used if the user doesn't 
  # supply one when creating the tree
  standard_comparator = (elem1, elem2) -> 
    if      (elem1 < elem2) then -1
    else if (elem1 > elem2) then  1
    else                          0
  
  # The properties of the RedBlackNode
  this.color 
  this.left
  this.key
  this.value
  this.right
  this.comparator
  
  # Constructor to create new instance of RedBlackNode.
  # The comparator argument is optional. 
  constructor: (color, left, key, value, right, comparator) -> 
    this.color      = color
    this.left       = left
    this.key        = key
    this.value      = value
    this.right      = right 
    this.comparator = if (comparator) then  else standard_comparator
  
  # Given a key it finds the value, if any.
  get: (key) -> 
    comp = this.comparator(key, this.key)
    if      (comp < 0) then this.left.get(key)
    else if (comp > 0) then this.right.get(key)
    else                    new Some(this.value)
      
  # Finds the smallest key in the tree 
  # Complexity of O ( log n )
  minKey: () -> 
    if (this.left.isEmpty()) then this.key else this.left.minKey()

  # Finds the largest key in the tree 
  # Complexity of O ( log n )
  maxKey: () ->     
    if (this.right.isEmpty()) then this.key else this.right.maxKey()
  
  # Checks if the given key exists in the tree
  containsKey: (key) -> 
    comp = this.comparator(key, this.key)
    if      (comp < 0) then this.left.containsKey(key)
    else if (comp > 0) then this.right.containsKey(key)
    else true 
  
  # returns a sorted List with all of the keys by doing an 
  # inorder traversal 
  keys: () -> this.inorderMap( (key,value) -> key )
      
  # returns a sorted List with all of the values by doing an 
  # inorder traversal
  values: () -> this.inorderMap( (key,value) -> value )
  
  # Returns the result of applying the function 'func' on each 
  # key,value pair of the tree during an inorder traversal 
  inorderMap: (f) -> 
    smaller = if !this.left.isEmpty()  then this.left.inorderMap(f)  else new Nil()
    bigger  = if !this.right.isEmpty() then this.right.inorderMap(f) else new Nil()
    that = new List(f(this.key, this.value))    
    smaller.append( that ).append(bigger)
    
  # Returns a new tree with the inserted element.
  insert: (key,value) -> 
    __insert = (tree) => 
      {color: c, left: l, key: k, value: v, right: r} = tree
      compare = this.comparator(key, k)
      
      if (tree.isEmpty()) 
        new RedBlackNode(RED, new RedBlackLeaf(BLACK), key, value, new RedBlackLeaf(BLACK))
      else if (compare < 0) 
        balance(c, __insert(l), k, v, r)
      else if (compare > 0)
        balance(c, l, k,v, __insert(r))
      else
        tree
      
    t = __insert(this)
    new RedBlackNode(BLACK, t.left, t.key, t.value, t.right)
  
  # Returns a new tree without the 'key'
  # Port from this racket example: http://matt.might.net/articles/red-black-delete/
  remove: (key) -> 
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
         new RedBlackLeaf(BLACK)
       else if (tree.color == BLACK)
         new RedBlackLeaf(DOUBLE_BLACK)
     
      # Removing a node with one child 
      else if (isNodeWithOneChildLeft()) # I can probably use the option here (i.e.) this.right.getOrElse(this.left.getOrElse())
        new RedBlackNode( BLACK, tree.left.left, tree.left.key, tree.left.value, tree.left.right)
      else if (isNodeWithOneChildRight())
        new RedBlackNode( BLACK, tree.right.left, tree.right.key, tree.right.value, tree.right.right)
    
      # Removing an internal node 
      else if (isInternalNode())
        # Convert a removal of an internal noe to a node with a most one child. 
        # Find the largest element in the left subtree, use that value for the new tree
        # and remove the other node
        max         = tree.left.maxKey()
        value       = tree.get(max).get
        newLeftTree = tree.left.remove(max)
        bubble( tree.color, newLeftTree, max, value, tree.right)
      else
        new RedBlackNode(tree.color, tree.left, tree.key, tree.value, tree.right)
        
    # Search for the subtree to remove the element from. Keep the references
    # to the tree that don't contain the element. I.e. if the element we're looking
    # for is in the right subtree we can just reuse the reference to the left subtree
    # in the new tree we're creating.
    compare = this.comparator(key, this.key)
    if (compare < 0)
      new RedBlackNode(this.color, this.left.remove(key), this.key, this.value, this.right)
    else if (compare > 0)
      new RedBlackNode(this.color, this.left, this.key, this.value, this.right.remove(key))
    else 
      __rm(this)
  
  # The bubble procedure moves double-blacks from children to parents, 
  # or eliminates them entirely if possible.
  # A black is substracted from the children, and added to the parent:
  bubble = (color, left, key, value, right) -> 
    if ( left.color == DOUBLE_BLACK || right.color == DOUBLE_BLACK)
      balance( 
        color.add(), 
        new RedBlackNode(left.color.subtract(), left.left, left.key, left.value, left.right),
        key, 
        value,
        new RedBlackNode(right.color.subtract(), right.left, right.key, right.value, right.right))
    else 
      new RedBlackNode(color, left, key, value, right)
      
  # This function balances the tree by eliminating any black-red-red path in the tree.
  # This situation can occur in any of four configurations:
  #                                                                                   
  # Reading the nodes from top to bottom:                                              
  # 
  # 1. Black node followed by a red left node followed by a red left node                                        
  # 2. Black node followed by a red left node followed by a red right node                                       
  # 3. Black node followed by a red right node followed by a red right node                                      
  # 4. Black node followed by a red right node followed by a red left node                                       
  #                                                                                   
  # The solution is always the same: Rewrite the black-red-red path as a red node with
  # two black children.
  #
  # However to support removal two additional colors have been addded to the mix:
  # Negative-black and double black.
  #
  # The double black can occur instead of black in the four configurations above. 
  # The solution is then to convert it into a black node with two black children. 
  #
  # Luckily the same code can handle both the black and double black cases by using a 
  # little trick: Each color has a `subtract` and an `add` method which returns another 
  # color (see each color object for more information). Instead of rewriting 
  # "the black/double black-red-red"" into a red node with two black children we just 
  # subtract the color of the root thus turning black into red and double-black into black.
  #
  # The negative black node can occur in the following two configurations:
  #
  # 1. Double black followed by left negative black whith two black children
  # 2. Double black followed by right negative black with two black children
  #
  # The solution is to transform it into a node with two black children and a left (or right
  # depending on the initial configuration) red node.                             
  balance = (color, left, key, value, right) ->
    
    leftFollowedByLeft   = () -> 
      (!left.isEmpty() && !left.left.isEmpty()) && 
      (color == BLACK || color == DOUBLE_BLACK) and left.color == RED and left.left.color == RED
      
    leftFollowedByRight  = () -> 
      (!left.isEmpty() && !left.right.isEmpty()) && 
      (color == BLACK || color == DOUBLE_BLACK) and left.color == RED and left.right.color == RED
      
    rightFollowedByLeft  = () ->
      (!right.isEmpty() && !right.left.isEmpty()) && 
      (color == BLACK || color == DOUBLE_BLACK) && right.color == RED && right.left.color  == RED
      
    rightFollowedByRight = () -> 
      (!right.isEmpty() && !right.right.isEmpty()) && 
      (color == BLACK || color == DOUBLE_BLACK) && right.color == RED && right.right.color == RED
    
    leftIsNegativeBlack  = () -> (!left.isEmpty()) && left.color == NEGATIVE_BLACK
    
    rightIsNegativeBlack = () -> (!right.isEmpty()) && right.color == NEGATIVE_BLACK
      
    if (leftFollowedByLeft())
      new RedBlackNode(color.subtract(), # The root color is subtracted. This takes care of double black
        new RedBlackNode(BLACK,left.left.left,left.left.key,left.left.value,left.left.right), 
        left.key, 
        left.value,
        new RedBlackNode(BLACK,left.right,key, value,right)) 
    else if (leftFollowedByRight())
      new RedBlackNode(color.subtract(), 
        new RedBlackNode(BLACK,left.left,left.key,left.value,left.right.left), 
        left.right.key,
        left.right.value, 
        new RedBlackNode(BLACK,right.right.right,key, value,right)) 
    else if (rightFollowedByLeft())
      new RedBlackNode(color.subtract(), 
        new RedBlackNode(BLACK,left,key, value,right.left.left), 
        right.left.key, 
        right.left.value,
        new RedBlackNode(BLACK,right.left.right,right.key,right.value,right.right)) 
    else if (rightFollowedByRight())
      new RedBlackNode(color.subtract(), 
        new RedBlackNode(BLACK,left,key, value,right.left), 
        right.key,
        right.value, 
        new RedBlackNode(BLACK,right.right.left,right.right.key,right.right.value,right.right.right)) 
    else if (leftIsNegativeBlack())
      new RedBlackNode(BLACK,
        new RedBlackNode(BLACK,
          balance( RED,left.left.left, left.left.key,left.left.value, left.left.right ),
          left.key,
          left.value,
          left.right.left
        ),
        left.right.key,
        left.right.value,
        new RedBlackNode(BLACK,right.left.right, key,value, right)
      )
    else if (rightIsNegativeBlack())
      new RedBlackNode(
        BLACK,
        new RedBlackNode(
          BLACK,
          left,
          right.key,
          right.value,         
          right.left.left
        ),
        right.right.key,     
        right.right.value,
        new RedBlackNode(
          BLACK,
          right.left.right,
          key,
          value,               
          balance( RED, right.right.left, right.left.key, right.left.value, right.right.right )
        )
      )
    else
      new RedBlackNode(color, left, key, value, right)
  
  # A node is never empty.
  isEmpty: () -> false

# Exporing objects if people are using this as a node module
if exports?
  exports.Leaf = RedBlackLeaf
  exports.RedBlackNode = RedBlackNode
  exports.RED = RED
  exports.BLACK = BLACK
  
