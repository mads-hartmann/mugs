###*
  Random Access List 

  Implementation of a Random Access List as described in the 
  paper Purely Functional Random Access List by Chris Okasaki.
  
  <pre>
  --------------------------------------------------------
  Core operations of the Random Access List ADT 
  --------------------------------------------------------
  lookup(item)                                    O(log n)
  update(index,item)                              O(log n)
  </pre>
  
  @author Mads Hartmann Jensen
  
  @class  Random Access List 
  @param  items (repeatable) The items to add to the 
                Random Access List
###
RandomAccessList = (items...) ->
  # TODO: This is just a hack till I figure out how to do the 
  # skew binary decomposition of the elements

  # I'm going to cons the elements onto the list so I need to reverse
  # to preserve the order
  
  if items.length > 0 
    reversed = []
    for item in [items.length-1..0]
      reversed.push(items[item])
    ral = this.buildFromList(new List())
    for item in reversed 
      ral = this.cons(item, ral)
    ral
  else 
    this.__trees = new List()
    this

###*
  Creates a Random Access List from an item and another Random 
  Access List Trees. 

  @private 
  @param item The item to add to the front of the list
  @param ral  The Random Access List to prepend the item to
  @return     A new Random Access List with the new element as the head
###
RandomAccessList.prototype.cons = (item, ral) -> 
  trees = ral.__trees
  if (!trees.get(0).isEmpty() && !trees.get(1).isEmpty())
    size1 = trees.get(0).get().size
    size2 = trees.get(1).get().size
    if size1 == size2 
      newList = new List().cons(
        new CompleteBinaryTreeNode(item,trees.get(0).get(), trees.get(1).get()),
        trees.tail().tail()
      )
      this.buildFromList(newList)
    else
      newList = new List().cons(
        new CompleteBinaryTreeLeaf(item),
        trees
      )
      this.buildFromList(newList)
  else 
    newList = new List().cons(
      new CompleteBinaryTreeLeaf(item),
      trees
    )
    this.buildFromList(newList)

###*
  Returns the number of items in the collection
  
  @return The number of items in the collection
###
RandomAccessList.prototype.size = () -> 
  recSize = (treeList) ->
    if treeList.isEmpty()
      0 
    else 
      treeList.head().size + recSize(treeList.tail())
  recSize(this.__trees)

###*
  Gets the element at the given index

  @param  index  The index of the element to get
  @return        The element at location index
###
RandomAccessList.prototype.lookup = (index) ->
  # Recursivly searched throgu the list of trees. 
  recLookup = (treeList, index) -> 
    tree = treeList.head()
    if index < tree.size 
      tree.lookup(index) 
    else 
      recLookup(treeList.tail(), index-tree.size)
  recLookup(this.__trees, index)
  
###*
  Creates a new RandomAccessList which is identical to this one
  except for the element at the given index which is replaced
  with item
  
  TODO: Can this be implemented w/o recursion? 
  
  @param  index  The index of the item you want to replace
  @param  item   The item you want to replace with the existing one
  @return        A new RandomAccessList with the element at the given
                 index replaced with the item
###
RandomAccessList.prototype.update = (index, item) ->
  recUpdate = (treeList, index) -> 
    tree = treeList.head()
    if index < tree.size
      treeList.tail().prepend(tree.update(index,item))
    else 
      recUpdate(treeList.tail(), index - tree.size).prepend(tree)
  newTreeList = recUpdate(this.__trees, index)
  this.buildFromList(newTreeList)

###
  Constructs a new RandomAccessList from a list of Complete Binary 
  Trees. This is used internally. 

  @private 
###
RandomAccessList.prototype.buildFromList = (list) -> 
  ral = new RandomAccessList()
  ral.__trees = list
  ral