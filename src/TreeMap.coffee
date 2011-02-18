if require?
  RedBlackNodeWrapper = require('../src/RedBlackTree')
  RedBlackNode        = RedBlackNodeWrapper.RedBlackNode
  RedBlackLeaf        = RedBlackNodeWrapper.Leaf
  RED                 = RedBlackNodeWrapper.RED
  BLACK               = RedBlackNodeWrapper.BLACK


###*
  @class Map based on a Red-Black Tree
###
class TreeMap
  
  # Delegate tree 
  this.tree
  
  constructor: (key,value, comparator) -> 
    this.tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), key, value, new RedBlackLeaf(BLACK), comparator)
    if comparator? then this.tree.comparator = comparator
  
  # Return a new TreeMap containing the given (key,value) pair.
  insert: (key, value) -> this.constructFromTree(this.tree.insert(key,value))
  
  # If a (key,value) pair exists return Some(value), otherwise None()
  get: (key) -> this.tree.get(key)
  
  # Returns a new TreeMap without the given (key,value) pair with the 
  # given key
  remove: (key) -> this.constructFromTree(this.tree.remove(key))
  
  # Returns a sorted list containing all of the keys in the TreeMap
  keys: () -> this.tree.keys()
  
  # Returns a sorted list containing all of the values in the TreeMap
  values: () -> this.tree.values()
  
  # Used to construct a TreeMap from RedBlackTree. This is intended 
  # for internal use only. Would've marked it private if I could.
  constructFromTree: (tree) -> 
    set = new TreeMap()
    set.tree = tree
    set
    
if exports?
  exports.TreeMap = TreeMap