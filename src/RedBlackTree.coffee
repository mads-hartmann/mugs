###
    _____             _    ____                       
   / ____|           | |  |  _ \                      
  | |      ___   ___ | |  | |_) | ___  __ _ _ __  ___ 
  | |     / _ \ / _ \| |  |  _ < / _ \/ _` | '_ \/ __|
  | |____| (_) | (_) | |  | |_) |  __/ (_| | | | \__ \
   \_____|\___/ \___/|_|  |____/ \___|\__,_|_| |_|___/
    
  Red-Black Tree. 
  
  invariant 1: No red node has a red child
  invariant 2: Every path from the root to an empty node 
               contains the same number of black nodes
  
  Mads Hartmann Jensen (mads379@gmail.com)
###

Option   = require './option'
Some     = Option.Some
None     = Option.None

RED   = { color: "RED" }    # the color property is only for debuggin
BLACK = { color: "BLACK" }  # the color property is only for debuggin

STANDARD_COMPARATOR = (elem1, elem2) -> 
  if      (elem1 < elem2) then -1
  else if (elem1 > elem2) then  1
  else                          0

Leaf = {
  left: new None(),
  right: new None(),
  element: new None(),
  color: BLACK,
  isEmpty: () -> true
}

class RedBlackTree 
  
  this.color 
  this.left
  this.element
  this.right
  this.comparator 
  
  ###
    @param  comparator  An optional function used to compare the elements in the tree.
  ###
  constructor: (color, left, element, right, comparator) -> 
    this.color      = color
    this.left       = left
    this.element    = element
    this.right      = right 
    this.comparator = if (comparator) then comparator else STANDARD_COMPARATOR

  ###
    Checks if the given element exists in the tree
  ###
  contains: (element) -> 
    __contains = (tree) => 
      {left: l, element: e, right: r} = tree
      compare = this.comparator(element,e)
      
      if      (tree.isEmpty()) then  false
      else if (compare < 0)    then  __contains(l)
      else if (compare > 0)    then  __contains(r)
      else                           true
    __contains(this)
  
  ###
    Returns a new tree with the inserted element.
  ###
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
  
  ###
    This function balances the tree by eliminating any black-red-red path in the tree.  
    This situation can occur in any of four configurations:                            
                                                                                     
    Reading the nodes from top to bottom:                                              
      red left node followed by a red left node                                        
      red left node followed by a red right node                                       
      red right node followed by a red right node                                      
      red right node followed by a red left node                                       
                                                                                     
    The solution is always the same: Rewrite the black-red-red path as a red node with  
    two black children.                                                                
  ###
  balance = (color, left, element, right) ->
  
    leftFollowedByLeft = () -> 
      (!left.isEmpty() && !left.left.isEmpty()) && 
      color == BLACK and left.color == RED and left.left.color == RED
      
    leftFollowedByRight = () -> 
      (!left.isEmpty() && !left.right.isEmpty()) && 
      color == BLACK and left.color == RED and left.right.color == RED
      
    rightFollowedByLeft = () ->
      (!right.isEmpty() && !right.left.isEmpty()) && 
      color == BLACK and right.color == RED and right.left.color  == RED
      
    rightFollowedByRight = () -> 
      (!right.isEmpty() && !right.right.isEmpty()) and 
      color == BLACK and right.color == RED and right.right.color == RED
      
    if (leftFollowedByLeft())
      new RedBlackTree(RED, 
        new RedBlackTree(BLACK,left.left.left,left.left.element,left.left.right), 
        left.element, 
        new RedBlackTree(BLACK,left.right,element,right)) 
    else if (leftFollowedByRight())
      new RedBlackTree(RED, 
        new RedBlackTree(BLACK,left.left,left.element,left.right.left), 
        left.right.element, 
        new RedBlackTree(BLACK,right.right.right,element,right)) 
    else if (rightFollowedByLeft())
      new RedBlackTree(RED, 
        new RedBlackTree(BLACK,left,element,right.left.left), 
        right.left.element, 
        new RedBlackTree(BLACK,right.left.right,right.element,right.right)) 
    else if (rightFollowedByRight())
      new RedBlackTree(RED, 
        new RedBlackTree(BLACK,left,element,right.left), 
        right.element, 
        new RedBlackTree(BLACK,right.right.left,right.right.element,right.right.right)) 
    else
      new RedBlackTree(color, left, element, right)
  
  isEmpty: () -> false

exports.Leaf = Leaf
exports.RedBlackTree = RedBlackTree
exports.RED = RED
exports.BLACK = BLACK
