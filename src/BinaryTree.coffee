###
    _____             _    ____                       
   / ____|           | |  |  _ \                      
  | |      ___   ___ | |  | |_) | ___  __ _ _ __  ___ 
  | |     / _ \ / _ \| |  |  _ < / _ \/ _` | '_ \/ __|
  | |____| (_) | (_) | |  | |_) |  __/ (_| | | | \__ \
   \_____|\___/ \___/|_|  |____/ \___|\__,_|_| |_|___/
    
  BinaryTree. 
    
  Example: 
    x < 0 if a < b,
    x > 0 if a > b,
    x = 0 otherwise
  
  Mads Hartmann Jensen (mads379@gmail.com)
  
###

Option   = require './option'
Some     = Option.Some
None     = Option.None



STANDARD_COMPARATOR = (elem1, elem2) -> 
  if      (elem1 < elem2) then -1
  else if (elem1 > elem2) then  1
  else                          0

Leaf = ( () ->  # We will only ever need one instance of Leaf. 
  this.left    = new None()
  this.right   = new None()
  this.element = new None()
  this.isEmpty = () -> true 
  this
)()


class BinaryTree
  
  constructor: (@left, @element, @right, c) -> 
    this.comparator = if(c != undefined) then c else STANDARD_COMPARATOR
  
  isEmpty: () -> false
    
  contains: (element) -> 
    __contains = (tree) => 
      {left: l, element: e, right: r} = tree
      compare = this.comparator(element,e)
      if (tree.isEmpty())
        false
      else if (compare < 0)
        __contains(l)
      else if (compare > 0 and not r.isEmpty())
        __contains(r)
      else 
        true
    __contains(this)
  
  insert: (element) -> 
    __insert = (tree) => 
      {left: l, element: e, right: r} = tree
      compare = this.comparator(element, e)
      if (tree.isEmpty())
        new BinaryTree(Leaf, element, Leaf)
      else if (compare < 0)
        new BinaryTree(__insert(l),e, r)
      else if (compare > 0)
        new BinaryTree(l,e, __insert(r))
      else 
        tree
    __insert(this)
      
  
exports.Leaf = Leaf
exports.BinaryTree = BinaryTree