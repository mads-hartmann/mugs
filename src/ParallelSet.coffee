###
  @fileoverview Contains the implementation of a parallel Set implemented using webworkers
  @author Mads Hartmann Jensen
###

mugs.provide("mugs.parallel.Set")

mugs.require('mugs.RedBlackLeaf')
mugs.require('mugs.RedBlackNode')
mugs.require("mugs.HashMap")

###
  @class mugs.parallel.Set provides the implementation of a parallel Set.
###
mugs.parallel.Set = (items, comparator, initialize) ->
  treeUnderConstruction = new mugs.LLRBLeaf()
  if items instanceof Array and items.length > 0
    for item in items
      treeUnderConstruction = treeUnderConstruction.insert(item, item)
  this.tree_ = treeUnderConstruction
  this.tree_.comparator = comparator if comparator?
  
  # There's a big possibility that the Set will be instructed to carry out
  # another operation before a an ealier one finishes. Because of this the 
  # Set will associate an msgId with each operation. When a result is sent from
  # the worker the handle with the specific msgId is updated. 
  this.nextMsgId_ = 0 
  this.handles_ = new mugs.HashMap([])
  
  # construct the workers 
  this.leftWorker_  = new Worker(mugs.basePath+'/ParallelSetWorker.js')
  this.rightWorker_ = new Worker(mugs.basePath+'/ParallelSetWorker.js')

  # This will get invoked whenever the left worker is done processing an operation. 
  this.leftWorker_.addEventListener('message',  (event) => 
    msgId  = event.data.msgId 
    handle = this.handles_.get(msgId).get()
    handle.leftMapped = event.data.result)

  # This will get invoked whenever the right worker is done processing an operation. 
  this.rightWorker_.addEventListener('message', (event) => 
    msgId  = event.data.msgId 
    handle = this.handles_.get(msgId).get()
    handle.rightMapped = event.data.result)
  
  # Initialize the webworkers. The webworkers need to load additional script files
  # (because they don't share any global variables). 
  initMsg = { 'operation' : "init", 'args' : [mugs.basePath] }
  this.leftWorker_.postMessage( initMsg )
  this.rightWorker_.postMessage( initMsg )
  this

###*
  Insert an item in the set. If the set already contains an item equal to the given value,
  it is replaced with the new value.

  @param item The item to insert into the set
  @param callback The function to invoke with the resulting Set
###
mugs.parallel.Set.prototype.insert = ( item, callback ) ->
  callback(this.buildFromTree_(this.tree_.insert(item,item)))

###*
  Delete an item from the set

  @param item The item to remove from the set
  @param callback The function to invoke with the resulting Set
###
mugs.parallel.Set.prototype.remove = ( item, callback ) ->
  callback(this.buildFromTree_(this.tree_.remove(item)))

###*
  Tests if the set contains the item

  @param item The item to check for
###
mugs.parallel.Set.prototype.contains = ( item ) ->
  this.tree_.containsKey( item )

###
  Returns a new mugs.parallel.Set with the values of applying the function 'f' on each
  item in the Set

  @param f The function to apply on each item
  @param callback The function to invoke with the resulting Set
###
mugs.parallel.Set.prototype.map = (f, callback) ->
  this.parallelExecute_("map", f, callback)

###
  Returns a new collection with the concatenated values of applying the function 'f' on
  each item in the Set. The function 'f' is expected to return an object
  that implements the forEach method itself.

  @param f The function to apply on each item
  @param callback The function to invoke with the resulting Set
###
mugs.parallel.Set.prototype.flatMap = (f, callback) ->
  this.parallelExecute_("flatMap" , f, callback)

###
  Create a new mugs.parallel.Set with the items which satisfies the predicate
  function 'f'.

  @param f        The predicate function to apply on each item. If the function
                  returns true the item will be in the resulting Set.
  @param callback The function to invoke with the resulting Set
###
mugs.parallel.Set.prototype.filter = (f, callback) ->
  piviotFunction = (item) -> if f(item) then [item] else []
  this.parallelExecute_("filter", f, callback, piviotFunction)

###
  Returns a mugs.List with all of the values in the Set
###
mugs.parallel.Set.prototype.values = (f, callback) ->
  this.tree_.values()

###
  Executes an operation in a parallel manner.

  @param operation      The name of the operation the webworker should execute
  @param f              The function the webworker should use when iterating the items
  @param callback       The function to invoke once the resulting mugs.parallel.Set is ready
  @param pivotFunction  A function to invoke on the pivot item. By default it will
                        wrap the result of applying f on the item in an array. This 
                        is needed because 'filter' will have to turn a false into []
                        rather than [false] as the default function would produce.
  @private
###
mugs.parallel.Set.prototype.parallelExecute_ = (operationName, f, callback, pivotFunction) ->
  tree  = this.tree_
  left  = tree.left.map( (l)  -> l.values().asArray() ).getOrElse([])
  right = tree.right.map( (r) -> r.values().asArray() ).getOrElse([])

  handle = {}
  handle.leftMapped  = null
  handle.rightMapped = null
  
  this.nextMsgId_ = this.nextMsgId_ + 1
  this.handles_ = this.handles_.insert(this.nextMsgId_, handle)
   
  this.leftWorker_.postMessage({
    'operation' : operationName, 
    'args'      : [left,  f.toString()], 
    'msgId'        : this.nextMsgId_ 
  })
                                  
  this.rightWorker_.postMessage({ 
    'operation' : operationName, 
    'args'      : [right, f.toString()],  
    'msgId'        : this.nextMsgId_ 
  })

  q = pivotFunction || (item) -> [f(item)]

  this.wait_(q(tree.value),  callback, this.nextMsgId_)

###
  Waits for the webworkers to finish their work before invoking the callback function
  with the resulting mugs.parallel.Set

  @private
###
mugs.parallel.Set.prototype.wait_ = (piviot, callback, id) ->
  that = this
  handle = this.handles_.get(id).get()
  if handle.leftMapped? and handle.rightMapped?
    result = handle.leftMapped.concat(piviot.concat(handle.rightMapped))
    callback(new mugs.parallel.Set(result, this.comparator))
  else
    setTimeout(`function(){ that.wait_(piviot,callback,id) }`,10)

###*
  Used to construct a mugs.parallel.Set from a mugs.RedBlackTree. This is intended
  for internal use only.

  @private
###
mugs.parallel.Set.prototype.buildFromTree_ = (tree) ->
  set               = new mugs.parallel.Set([], this.comparator)
  set.tree_         = tree
  set