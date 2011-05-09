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
  --------------------------------------------------------
  Core operations of the Queue ADT
  --------------------------------------------------------
  enqueue()                               (amortized) O(1)
  dequeue(elem)                                       O(1)
  top()                                               O(1)
  --------------------------------------------------------
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

mugs.Queue.prototype = new mugs.Collection() 

###*
  Removes the front element from the queue

  @return A new queue without the former front element
###
mugs.Queue.prototype.dequeue = () ->
  this.buildFromLists(this.front__.tail(), this.rear__)

###*
  Adds a new element to the queue

  @param elem The element to add to the queue
  @return A new queue with the element in the back of the queue
###
mugs.Queue.prototype.enqueue = (elem) ->
  this.buildFromLists(this.front__, this.rear__.prepend(elem))

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
# Methods that Collection requires
### 

mugs.Queue.prototype.forEach = ( f ) -> 
  this.front__.forEach(f)
  this.rear__.reverse().forEach(f)

mugs.Queue.prototype.buildFromArray = ( arr ) ->
  new mugs.Queue(arr)  
