mugs.parallel = {}

mugs.parallel.Set = (items, comparator) -> 
  treeUnderConstruction = new mugs.LLRBLeaf() 
  if items instanceof Array and items.length > 0
    for item in items
      treeUnderConstruction = treeUnderConstruction.insert(item, item)
  this.tree = treeUnderConstruction  
  this.tree.comparator = comparator if comparator?
  this

mugs.parallel.Set.prototype.map = (f, callback) -> 
  tree  = this.tree 
  left  = tree.left.map( (l)  -> l.values().asArray() ).getOrElse([])
  right = tree.right.map( (r) -> r.values().asArray() ).getOrElse([])
  
  leftWorker  = new Worker('../bin/ParallelSetWorker.js')
  rightWorker = new Worker('../bin/ParallelSetWorker.js') 

  handle = {}
  handle.leftMapped  = null
  handle.rightMapped = null

  leftWorker.addEventListener('message',  (e) -> handle.leftMapped  = e.data )
  rightWorker.addEventListener('message', (e) -> handle.rightMapped = e.data ) 

  leftWorker.postMessage( { 'operation' : 'map', 'args' : [left,  f.toString()] })
  rightWorker.postMessage({ 'operation' : 'map', 'args' : [right, f.toString()] })

  this.wait(handle, f(tree.value),  callback) 

mugs.parallel.Set.prototype.filter = () -> 

mugs.parallel.Set.prototype.values = () -> this.tree.values()

mugs.parallel.Set.prototype.wait = (handle,piviot, callback) ->
  that = this
  if handle.leftMapped? and handle.rightMapped?
    result = handle.leftMapped.concat([piviot].concat(handle.rightMapped))
    callback(new mugs.parallel.Set(result, this.comparator))
  else 
    setTimeout(`function(){ that.wait(handle,piviot,callback) }`,10)
