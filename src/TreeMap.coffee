###*
  @fileoverview Contains the implementation of the Map data structure based on a Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
###
if require?
  RedBlackNodeWrapper = require('../src/RedBlackTree')
  RedBlackNode        = RedBlackNodeWrapper.RedBlackNode
  RedBlackLeaf        = RedBlackNodeWrapper.Leaf
  RED                 = RedBlackNodeWrapper.RED
  BLACK               = RedBlackNodeWrapper.BLACK

###*
  <p>TreeMap provides the implementation of the abstract data type 'Map' based on a Red Black Tree.</p>
  
  <p>The insert and contains methods have been implemented following Chris Okasaki's book 'purely functional 
  data structures' and the remove operations has been implemented following this blog: 
  http://matt.might.net/articles/red-black-delete/</p>
  
  <p>The asymptotic running time for important operations are below:</p>
  <pre>
     Method                 big-O
   --------------------------------------------------------------------
   - contains               O(logn)
   - filter                 TODO
   - values                 O(n)
   - insert                 O(logn)
   - insertAll              TODO
   - map                    TODO
   - remove                 O(logn)
   - removeAll              TODO
   - get                    O(logn)
   </pre>
   
   @class TreeMap provides the implementation of the abstract data type 'Map' based on a Red Black Tree. <br />
   @public
###    
TreeMap = (key,value, comparator) ->
  
  # Delegate tree 
  this.tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), key, value, new RedBlackLeaf(BLACK), comparator)
  
  this.tree.comparator = comparator if comparator?
  
  # Return a new TreeMap containing the given (key,value) pair.
  this.insert = (key, value) -> this.constructFromTree(this.tree.insert(key,value))
  
  # If a (key,value) pair exists return Some(value), otherwise None()
  this.get = (key) -> this.tree.get(key)
  
  # Returns a new TreeMap without the given (key,value) pair with the 
  # given key
  this.remove = (key) -> this.constructFromTree(this.tree.remove(key))
  
  # Returns a sorted list containing all of the keys in the TreeMap
  this.keys = () -> this.tree.keys()
  
  # Returns a sorted list containing all of the values in the TreeMap
  this.values = () -> this.tree.values()
  
  # Used to construct a TreeMap from RedBlackTree. This is intended 
  # for internal use only. Would've marked it private if I could.
  this.constructFromTree = (tree) -> 
    set = new TreeMap()
    set.tree = tree
    set
  
  this
    
if exports?
  exports.TreeMap = TreeMap