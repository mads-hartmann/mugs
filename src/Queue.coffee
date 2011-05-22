###*
  @fileoverview Contains the implementation of the Queue ADT based on two Lists as
                described in Chris Okasaki's book Purely Functional Data Structures. <br />

  @author Mads Hartmann Jensen (mads379@gmail.com)
### 

mugs.provide("mugs.Queue")
mugs.require("mugs.List")

###*
  Queue provides the implementation of the abstract data type Queue based on two Lists as
  described in Chris Okasaki's book Purely Functional Data Structures. The Queue contains
  the following operations:

  <pre>
  enqueue(item)                                       O(1)
  enqueueAll(items)                               O(items)
  front()                                             O(1)
  dequeue(elem)                           (amortized) O(1)
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
  tail()                                 (amortized) O(1)
  append(item)                                        O(1)
  appendAll(items)                                O(items)
  prepend(item)                                       O(1)
  prependAll(items)                               O(items)
  reverse()                                           O(n)
  </pre>

  @class Queue provides an implementation of the Queue ADT based on two Lists.
  @public
###
mugs.Queue = (items) ->
  if not items? || items.length == 0 
    this.front__ = new mugs.List()
    this.rear__ = new mugs.List()
  else 
    size = items.length
    half = Math.ceil(size / 2)
    f = items.slice(0,half)
    r = items.slice(half,size)
    this.front__ = new mugs.List(f)
    this.rear__ = new mugs.List(r).reverse()
  this

mugs.Queue.prototype = new mugs.Indexed()

###*
  Removes the front element from the queue

  @return A new queue without the former front element
###
mugs.Queue.prototype.dequeue = () ->
  this.buildFromLists(this.front__.tail(), this.rear__)

###*
  Adds a new element to the Queue

  @param elem The element to add to the queue
  @return A new queue with the element in the back of the queue
###
mugs.Queue.prototype.enqueue = (elem) ->
  this.buildFromLists(this.front__, this.rear__.prepend(elem))
  
###*
  Adds all the items of an array to the Queue
  
  @param items An array with the items to enqueue
  @return      A new queue with all of the items enqueued
###
mugs.Queue.prototype.enqueueAll = (items) -> 
  reversed = reversed = (items[i] for i in [items.length-1..0])
  this.buildFromLists(this.front__, this.rear__.prependAll(reversed))

###*
  Reads the front element in the queue

  @return The front element in the queue
###
mugs.Queue.prototype.front = () ->
  this.front__.head()

###*
  Return true if the collection is empty, otherwise false
  
  @return True if the collection is empty, otherwise false
###
mugs.Queue.prototype.isEmpty = () ->
  this.front__.isEmpty() && this.rear__.isEmpty()


###*
  Returns a List with all of the elements in the queue.

  @return A List with all of the elements in the queue.
###
mugs.Queue.prototype.values = () ->
  this.front__.appendAll(this.rear__.reverse().asArray())

###*
  Given two lists this will create a new queue. This is the method that makes sure the
  invariant "front is empty only if rear is empty" is kept.

  @param front The list that's going to be the front of the queue
  @param rear The list that's going to be the rear of the queue
  @private
###
mugs.Queue.prototype.buildFromLists = (front, rear) ->
  queue = new mugs.Queue()
  if front.isEmpty()
    queue.front__ = rear.reverse()
    queue.rear__ = front #front is empty so we use it instead of a new empty list.
  else
    queue.rear__ = rear
    queue.front__ = front
  queue

###
---------------------------------------------------------------------------------------------
Collection interface
---------------------------------------------------------------------------------------------
###

###*
  Applies function 'f' on each value in the collection. This return nothing and is only invoked
  for the side-effects of f.

  @param f The unary function to apply on each item in the collection.
###
mugs.Queue.prototype.forEach = ( f ) -> 
  this.front__.forEach(f)
  this.rear__.reverse().forEach(f)

###*
  @private
###
mugs.Queue.prototype.buildFromArray = ( arr ) ->
  new mugs.Queue(arr)

###
---------------------------------------------------------------------------------------------
Extensible interface
---------------------------------------------------------------------------------------------
###

###*
  Inserts the new item to the front of the Queue. This is equivalent to enqueue. The method 
  is needed so a Queue can be treated as an Extensible collection. runs in O(mugs.Queue.enqueue)
  
  @param item The item to add to the front of the Queue
  @return     A new queue with the item in front
###
mugs.Queue.prototype.insert = (item) ->
  this.enqueue(item)

###
  Removes an item from the Queue. Runs in O(n).
  
  @param item The item to remove from the Queue.
###
mugs.Queue.prototype.remove = (item) -> 
  if this.front__.contains(item)
    this.buildFromLists(this.front__.remove(item), this.rear__)
  else if this.rear__.contains(item)
    this.buildFromLists(this.front__,this.rear__.remove(item))
  else 
    this

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
mugs.Queue.prototype.get = (index) -> 
  if index <= this.front__.size() - 1
    this.front__.get(index)
  else
    this.rear__.get(index)

###*
  Update the value with the given index.

  @param  index   The index of the item to update
  @param  item    The item to replace with the current item
  @return         A new collection with the updated value.
###
mugs.Queue.prototype.update = (index, item) -> 
  if index <= this.front__.size() - 1
    this.buildFromLists(this.front__.update(index, item), this.rear__)
  else
    this.buildFromLists(this.front__,this.rear__.update(index, item))

###*
  Removes the item at the given index.

  @param  index  The index of the item to remove
  @return        A new collection without the item at the given index
###
mugs.Queue.prototype.removeAt = (index) -> 
  if index <= this.front__.size() - 1
    this.buildFromLists(this.front__.removeAt(index), this.rear__)
  else
    this.buildFromLists(this.front__,this.rear__.removeAt(index))

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
mugs.Queue.prototype.last = () -> 
  if this.rear__.isEmpty() 
    this.front__.last()
  else
    this.rear__.last()

###*
  Returns a mugs.Some with the first item in the collection if it's non-empty. 
  otherwise, mugs.None

  @return a mugs.Some with the first item in the collection if it's non-empty. 
          otherwise, mugs.None
###
mugs.Queue.prototype.first = () -> 
  this.front__.first()

###*
  Returns the first item in the collection. Throws an exception if the collection 
  is empty. 

  @return The first item in the collection. Throws an exception if the collection 
          is empty.
###
mugs.Queue.prototype.head = () ->
  this.front__.head()

###*
  Return the remainder of the queue after removing the front-most item

  @return The remainder of the queue after removing the front-most item
###
mugs.Queue.prototype.tail = () -> 
  this.dequeue()

###*
  Applies a binary operator on all items of the collection going left to right and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the items. The function is binary where 
  the first parameter is the value of the fold so far and the second is the current item. 

  @param seed The value to use when the collection is empty
  @return     A function which takes a binary function
###
mugs.Queue.prototype.foldLeft = (seed) -> (f) =>
  partialResult = this.front__.foldLeft(seed)(f)
  this.rear__.reverse().foldLeft(partialResult)(f)

###*
  Applies a binary operator on all items of the collection going right to left and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the items. The function is binary where 
  the first parameter is the value of the fold so far and the second is the current item. 

  @param seed The value to use when the collection is empty
  @return     A function which takes a binary function
###
mugs.Queue.prototype.foldRight = (seed) -> (f) =>
  partialResult = this.front__.foldRight(seed)(f)
  this.rear__.foldLeft(partialResult)(f)

###
---------------------------------------------------------------------------------------------
Directed interface
---------------------------------------------------------------------------------------------
###

###*
  Appends an item to the end of the Queue. 
  
  @return A new Queue with item at the end of the Queue
###
mugs.Queue.prototype.append = (item) ->
  this.enqueue(item)

###*
  Creates a new Queue with the items appended

  @param  items An array with the items to append to this queue.
  @return       A new queue with the items appended
###
mugs.Queue.prototype.appendAll = (items) ->
  this.enqueueAll(items)

###*
  Creates a new Queue with the item prepended

  @return A new Queue with the items prepended
###
mugs.Queue.prototype.prepend = (item) -> 
  this.buildFromLists(this.front__.prepend(item), this.rear__)
  
###*
  Creates a new Queue with the items prepended

  @return A new Queue with the items prepended
###
mugs.Queue.prototype.prependAll = (items) -> 
  this.buildFromLists(this.front__.prependAll(items), this.rear__)

###*
  Creates a new Queue with the items in reversed order
  
  @return A new Queue with the items in reversed order
###
mugs.Queue.prototype.reverse = () ->
  this.buildFromLists(this.rear__ , this.front__)