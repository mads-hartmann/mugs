###*
  Random Access List

  Implementation of a Random Access List as described in the
  paper Purely Functional Random Access List by Chris Okasaki.

  <pre>
  --------------------------------------------------------
  Core operations of the Random Access List ADT
  --------------------------------------------------------
  prepend(item)                                   O(1)
  head()                                          O(1)
  tail()                                          O(1)
  get(item)                                       O(log n)
  update(index,item)                              O(log n)
  </pre>

  @author Mads Hartmann Jensen

  @class  Random Access List
  @param  items (repeatable) The items to add to the
                Random Access List
###
mugs.RandomAccessList = (items...) ->

  # TODO: This is just a hack till I figure out how to do the
  # skew binary decomposition of the elements

  # I'm going to cons the elements onto the list so I need to reverse
  # to preserve the order
  if items.length > 0
    reversed = []
    for item in [items.length-1..0]
      reversed.push(items[item])
    ral = this.buildFromList(new mugs.List())
    for item in reversed
      ral = this.cons(item, ral)
    ral
  else
    this.__trees = new mugs.List()
    this

###*
  Create a new list by prepending the item

  @param  item The item to be the new head
  @return A new list with the item as the head
###
mugs.RandomAccessList.prototype.prepend = (item) ->
  this.cons(item,this)

###*
  Returns the first item in the list
  @return The first item in the list
###
mugs.RandomAccessList.prototype.head = () ->
  this.__trees.head().get(0)

###*
  Returns the rest of the list
  @return The rest of the list
###
mugs.RandomAccessList.prototype.tail = () ->
  tree = this.__trees.head()
  if tree.isLeaf
    this.buildFromList(this.__trees.tail())
  else
    list = this.__trees.tail().prepend(tree.right).prepend(tree.left)
    this.buildFromList(list)

###*
  Returns the number of items in the collection

  @return The number of items in the collection
###
mugs.RandomAccessList.prototype.size = () ->
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
mugs.RandomAccessList.prototype.get = (index) ->
  # Recursivly searched throgu the list of trees.
  recget = (treeList, index) ->
    tree = treeList.head()
    if index < tree.size
      tree.get(index)
    else
      recget(treeList.tail(), index-tree.size)
  recget(this.__trees, index)

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
mugs.RandomAccessList.prototype.update = (index, item) ->
  recUpdate = (treeList, index) ->
    tree = treeList.head()
    if index < tree.size
      treeList.tail().prepend(tree.update(index,item))
    else
      recUpdate(treeList.tail(), index - tree.size).prepend(tree)
  this.buildFromList(recUpdate(this.__trees, index))

###*
  Creates a Random Access List from an item and another Random
  Access List Trees.

  @private
  @param item The item to add to the front of the list
  @param ral  The Random Access List to prepend the item to
  @return     A new Random Access List with the new element as the head
###
mugs.RandomAccessList.prototype.cons = (item, ral) ->
  trees = ral.__trees
  if (!trees.get(0).isEmpty() && !trees.get(1).isEmpty())
    size1 = trees.get(0).get().size
    size2 = trees.get(1).get().size
    if size1 == size2
      newList = new mugs.List().cons(
        new mugs.CompleteBinaryTreeNode(item,trees.get(0).get(), trees.get(1).get()),
        trees.tail().tail()
      )
      this.buildFromList(newList)
    else
      newList = new mugs.List().cons(
        new mugs.CompleteBinaryTreeLeaf(item),
        trees
      )
      this.buildFromList(newList)
  else
    newList = new mugs.List().cons(
      new mugs.CompleteBinaryTreeLeaf(item),
      trees
    )
    this.buildFromList(newList)

###*
  Creates a new RandomAccessList without the item stored at given
  index

  @param index  The index of the element to remove
  @return       A new RandomAccessList without the item stored at given
                index
###
# mugs.RandomAccessList.prototype.remove = (index) ->
#   recRemove = (tree, treeList, i) ->
#     if index <= tree.size then else
#
#   # takes care of the special case where where the very first elemt is
#   # to be removed
#   if index == 0
#     tree = this.__trees.head()
#     if head.isLeaf
#       this.buildFromList(this.__trees.tail())
#     else
#       rest  = this.__trees.tail()
#       left  = this.__tree.head().left
#       right = this.__tree.head().right
#       this.buildFromList(rest.prepend(right).prepend(left))
#   else
#     recRemove(this.__trees.head(), this.__trees.tail(), index)

###*
  Constructs a new RandomAccessList from a list of Complete Binary
  Trees. This is used internally.

  @private
###
mugs.RandomAccessList.prototype.buildFromList = (list) ->
  ral = new mugs.RandomAccessList()
  ral.__trees = list
  ral