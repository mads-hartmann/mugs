###*
  @fileoverview Contains the implementation of the Stack data structure based on a List <br />

  @author Mads Hartmann Jensen (mads379@gmail.com)
### 

mugs.provide("mugs.Stack")

mugs.require("mugs.List")

###*
  Stack provides the implementation of the abstract data type Stack based on a List. The
  Stack contains the following operations:

  <pre>
  --------------------------------------------------------
  Core operations of the Stack ADT
  --------------------------------------------------------
  pop()                                               O(1)
  push( elem )                                        O(1)
  top()                                               O(1)
  --------------------------------------------------------
  </pre>

  @class Stack provides the implementation of the abstract data type Stack based on a List
  @param items An array of the items to construct the stack from. The last element will be 
               at the bottom of the stack.
  @public
###
mugs.Stack = (items) ->
  this.list = new mugs.List(items)
  this

mugs.Stack.prototype = new mugs.Collection() 

###*
  Removes the top element from the stack.

  @return A new stack without the former top element
  @complexity O(1)
###
mugs.Stack.prototype.pop = () ->
  this.buildFromList(this.list.tail())

###*
  Push an element on the stack

  @param elem the element to push on the stack
  @return A new stack with the new element on top
  @complexity O(1)
###
mugs.Stack.prototype.push = (elem) ->
  this.buildFromList(this.list.prepend(elem))
  
###*
  
###
mugs.Stack.prototype.pushAll = (items) -> 
  this.buildFromList(this.list.prependAll(items))

###*
  Returns the top element of the stack.

  @return the top element.
  @complexity O(1)
###
mugs.Stack.prototype.top = () ->
  this.list.head()

###*
  Returns a List with all of the elements in the stack

  @return A list with all of the elements in the Stack
  @complexity O(1)
###
mugs.Stack.prototype.values = () ->
  this.list

###*
  This will build a new Stack from a List. This is used internally.

  @complexity O(1)
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
  Inserts a new item to the top of the Stack. This is simply calling push. The method is needed
  so a Stack can be treated as an Extensible collection. runs in O(mugs.Stack.push)
  
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
  @complexity O(1)
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
  this.pushAll(items)

###*
  Returns a new Stack with the elements in reversed order
  
  @return A new Stack with the elements in reversed order
###
mugs.Stack.prototype.reverse = () ->
  this.buildFromList(this.list.reverse())
