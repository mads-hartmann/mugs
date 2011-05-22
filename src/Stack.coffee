###*
  @fileoverview Contains the implementation of the Stack data structure based on a List
  @author Mads Hartmann Jensen (mads379@gmail.com)
### 

mugs.provide("mugs.Stack")

mugs.require("mugs.List")

###*
  Stack provides the implementation of the abstract data type Stack based on a List. The
  Stack contains the following operations:

  <pre>
  pop()                                               O(1)
  push( elem )                                        O(1)
  pushAll(items)                                  O(items)
  top()                                               O(1)
  isEmpty()                                           O(1)
  forEach(f)                                     O(n*O(f))
  insert(item)                                        O(1)
  remove(item)                                        O(n)
  get(index)                                          O(n)
  update(index,item)                                  O(n)
  removeAt(index)                                     O(n)
  last()                                              O(n)
  first()                                             O(1)
  head()                                              O(1)
  tail()                                              O(1)
  append(item)                                        O(n)
  appendAll(items)                              O(n)*items
  prepend(item)                                       O(1)
  prependAll(items)                               O(items)
  reverse()                                           O(n)  
  </pre>

  @class Stack provides the implementation of the abstract data type Stack based on a List
  @param items An array of the items to construct the stack from. The last element will be 
               at the bottom of the stack.
  @public
###
mugs.Stack = (items) ->
  this.list = new mugs.List(items)
  this

mugs.Stack.prototype = new mugs.Indexed()

###*
  Removes the top element from the stack.

  @return A new stack without the former top element
###
mugs.Stack.prototype.pop = () ->
  this.buildFromList(this.list.tail())

###*
  Push an element on the stack

  @param elem the element to push on the stack
  @return A new stack with the new element on top
###
mugs.Stack.prototype.push = (elem) ->
  this.buildFromList(this.list.prepend(elem))
  
###*
  Returns a new stack with all of the items pushed on top. The last item of 
  'items' will be on the top of the stack
  
  @param items An array with items to push upon the stack
  @return A new stack with all of the items pushed on top. The last item of 
          'items' will be on the top of the stack 
###
mugs.Stack.prototype.pushAll = (items) -> 
  newStack = this
  for item in items
    newStack = newStack.push(item)
  newStack

###*
  Returns the top element of the stack.

  @return the top element.
###
mugs.Stack.prototype.top = () ->
  this.list.head()

###*
  Returns a List with all of the elements in the stack

  @return A list with all of the elements in the Stack
###
mugs.Stack.prototype.values = () ->
  this.list

###*
  This will build a new Stack from a List. This is used internally.

  @private
###
mugs.Stack.prototype.buildFromList = (list) ->
  stack = new mugs.Stack()
  stack.list = list
  stack

###
---------------------------------------------------------------------------------------------
Collection interface
---------------------------------------------------------------------------------------------
###

###*
  Return true if the collection is empty, otherwise false
  
  @return True if the collection is empty, otherwise false
###
mugs.Stack.prototype.isEmpty = () ->
  this.list.isEmpty()

mugs.Stack.prototype.forEach = ( f ) -> 
  this.list.forEach(f)

mugs.Stack.prototype.buildFromArray = ( arr ) -> 
  new mugs.Stack(arr)


###
---------------------------------------------------------------------------------------------
Extensible interface
---------------------------------------------------------------------------------------------
###

###*
  Inserts the new item at the top of the Stack. This is equivalent to push(). This is needed so a 
  Stack can be treated as an Extensible collection. runs in O(mugs.Stack.push)
  
  @param item The item to add to the top of the Stack
###
mugs.Stack.prototype.insert = (item) ->
  this.push(item)

###
  Removes an item from the Stack. Runs in O(n).
  
  @param item The item to remove from the Stack.
###
mugs.Stack.prototype.remove = (item) -> 
  this.buildFromList(this.list.remove(item))

###
---------------------------------------------------------------------------------------------
Indexed interface
---------------------------------------------------------------------------------------------
###

###*
  Return an Option containing the nth item in the collection.
  
  @param  index The index of the item to get
  @return       mugs.Some(item) is it exists, otherwise mugs.None
###
mugs.Stack.prototype.get = (index) -> 
  this.list.get(index)

###*
  Update the value with the given index.

  @param  index   The index of the item to update
  @param  item    The item to replace with the current item
  @return         A new collection with the updated value.
###
mugs.Stack.prototype.update = (index, item) -> 
  this.buildFromList(this.list.update(index,item))

###*
  Removes the item at the given index.

  @param  index  The index of the item to remove
  @return        A new collection without the item at the given index
###
mugs.Stack.prototype.removeAt = (index) -> 
  this.buildFromList(this.list.removeAt(index))
  
###
---------------------------------------------------------------------------------------------
Sequenced interface 
---------------------------------------------------------------------------------------------
###

###*
  Returns a mugs.Some with the last item in the collection if it's non-empty. 
  otherwise, mugs.None

  @return a mugs.Some with the last item in the collection if it's non-empty. 
          otherwise, mugs.None
###
mugs.Stack.prototype.last = () -> 
  this.list.last()

###*
  Returns a mugs.Some with the first item in the collection if it's non-empty. 
  otherwise, mugs.None

  @return a mugs.Some with the first item in the collection if it's non-empty. 
          otherwise, mugs.None
###
mugs.Stack.prototype.first = () -> 
  this.list.first()

###*
  Returns the remainder of the list after removing the top item

  @return The remainder of the list after removing the top item
###
mugs.Stack.prototype.tail = () ->
  this.buildFromList(this.list.tail())

###*
  Returns the first item in the collection. Throws an exception if the collection 
  is empty. 

  @return The first item in the collection. Throws an exception if the collection 
          is empty.
###
mugs.Stack.prototype.head = () ->
  this.list.head()

###*
  Applies a binary operator on all items of the collection going left to right and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the items. The function is binary where 
  the first parameter is the value of the fold so far and the second is the current item. 

  @param seed The value to use when the collection is empty
  @return     A function which takes a binary function
###
mugs.Stack.prototype.foldLeft = (seed) -> (f) =>
  this.list.foldLeft(seed)(f)  

###*
  Applies a binary operator on all items of the collection going right to left and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the items. The function is binary where 
  the first parameter is the value of the fold so far and the second is the current item. 

  @param seed The value to use when the collection is empty
  @return     A function which takes a binary function
###
mugs.Stack.prototype.foldRight = (seed) -> (f) =>
  this.list.foldRight(seed)(f)
###
---------------------------------------------------------------------------------------------
Directed interface
---------------------------------------------------------------------------------------------
###
  
###*
  Appends an item to the end (bottom) of the Stack. 
  
  @return A new Stack with item at the bottom of the Stack
###
mugs.Stack.prototype.append = (item) ->
  this.buildFromList(this.list.append(item))
  
###*
  Creates a new Stack with the items appended

  @example
  new mugs.Stack([1,2,3]).appendAll([4,5,6]);
  // returns a Stack with the element 1,2,3,4,5,6
  @param  items An array with the items to append to this Stack.
  @return       A new Stack with the items appended
###
mugs.Stack.prototype.appendAll = (items) ->
  this.buildFromList(this.list.appendAll(items))
  
###*
  Prepends a new item to the top of the Stack. Equivalent to push(). 
  
  @return A new stack with the item on top  
###
mugs.Stack.prototype.prepend = (item) -> 
  this.push(item)

###*
  Creates a new Stack with all of the items prepended
  
  @return A new Stack with all of the items prepended
###
mugs.Stack.prototype.prependAll = (items) -> 
  this.buildFromList(this.list.prependAll(items))

###*
  Returns a new Stack with the elements in reversed order
  
  @return A new Stack with the elements in reversed order
###
mugs.Stack.prototype.reverse = () ->
  this.buildFromList(this.list.reverse())