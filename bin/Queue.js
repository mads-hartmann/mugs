/**
  @fileoverview Contains the implementation of the Queue ADT based on two Lists as
                described in Chris Okasaki's book Purely Functional Data Structures. <br />

  @author Mads Hartmann Jensen (mads379@gmail.com)
*/var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
mugs.provide("mugs.Queue");
mugs.require("mugs.List");
/**
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
*/
mugs.Queue = function(items) {
  var f, half, r, size;
  if (!(items != null) || items.length === 0) {
    this.front__ = new mugs.List();
    this.rear__ = new mugs.List();
  } else {
    size = items.length;
    half = Math.ceil(size / 2);
    f = items.slice(0, half);
    r = items.slice(half, size);
    this.front__ = new mugs.List(f);
    this.rear__ = new mugs.List(r).reverse();
  }
  return this;
};
mugs.Queue.prototype = new mugs.Indexed();
/**
  Removes the front element from the queue

  @return A new queue without the former front element
*/
mugs.Queue.prototype.dequeue = function() {
  return this.buildFromLists(this.front__.tail(), this.rear__);
};
/**
  Adds a new element to the Queue

  @param elem The element to add to the queue
  @return A new queue with the element in the back of the queue
*/
mugs.Queue.prototype.enqueue = function(elem) {
  return this.buildFromLists(this.front__, this.rear__.prepend(elem));
};
/**
  Adds all the items of an array to the Queue

  @param items An array with the items to enqueue
  @return      A new queue with all of the items enqueued
*/
mugs.Queue.prototype.enqueueAll = function(items) {
  var i, reversed;
  reversed = reversed = (function() {
    var _ref, _results;
    _results = [];
    for (i = _ref = items.length - 1; (_ref <= 0 ? i <= 0 : i >= 0); (_ref <= 0 ? i += 1 : i -= 1)) {
      _results.push(items[i]);
    }
    return _results;
  })();
  return this.buildFromLists(this.front__, this.rear__.prependAll(reversed));
};
/**
  Reads the front element in the queue

  @return The front element in the queue
*/
mugs.Queue.prototype.front = function() {
  return this.front__.head();
};
/**
  Return true if the collection is empty, otherwise false

  @return True if the collection is empty, otherwise false
*/
mugs.Queue.prototype.isEmpty = function() {
  return this.front__.isEmpty() && this.rear__.isEmpty();
};
/**
  Returns a List with all of the elements in the queue.

  @return A List with all of the elements in the queue.
*/
mugs.Queue.prototype.values = function() {
  return this.front__.appendAll(this.rear__.reverse().asArray());
};
/**
  Given two lists this will create a new queue. This is the method that makes sure the
  invariant "front is empty only if rear is empty" is kept.

  @param front The list that's going to be the front of the queue
  @param rear The list that's going to be the rear of the queue
  @private
*/
mugs.Queue.prototype.buildFromLists = function(front, rear) {
  var queue;
  queue = new mugs.Queue();
  if (front.isEmpty()) {
    queue.front__ = rear.reverse();
    queue.rear__ = front;
  } else {
    queue.rear__ = rear;
    queue.front__ = front;
  }
  return queue;
};
/*
---------------------------------------------------------------------------------------------
Collection interface
---------------------------------------------------------------------------------------------
*/
mugs.Queue.prototype.forEach = function(f) {
  this.front__.forEach(f);
  return this.rear__.reverse().forEach(f);
};
mugs.Queue.prototype.buildFromArray = function(arr) {
  return new mugs.Queue(arr);
};
/*
---------------------------------------------------------------------------------------------
Extensible interface
---------------------------------------------------------------------------------------------
*/
/**
  Inserts the new item to the front of the Queue. This is equivalent to enqueue. The method
  is needed so a Queue can be treated as an Extensible collection. runs in O(mugs.Queue.enqueue)

  @param item The item to add to the front of the Queue
  @return     A new queue with the item in front
*/
mugs.Queue.prototype.insert = function(item) {
  return this.enqueue(item);
};
/*
  Removes an item from the Queue. Runs in O(n).

  @param item The item to remove from the Stack.
*/
mugs.Queue.prototype.remove = function(item) {
  if (this.front__.contains(item)) {
    return this.buildFromLists(this.front__.remove(item), this.rear__);
  } else if (this.rear__.contains(item)) {
    return this.buildFromLists(this.front__, this.rear__.remove(item));
  } else {
    return this;
  }
};
/*
---------------------------------------------------------------------------------------------
Indexed interface
---------------------------------------------------------------------------------------------
*/
/**

*/
mugs.Queue.prototype.get = function(index) {
  if (index <= this.front__.size() - 1) {
    return this.front__.get(index);
  } else {
    return this.rear__.get(index);
  }
};
/**

*/
mugs.Queue.prototype.update = function(index, item) {
  if (index <= this.front__.size() - 1) {
    return this.buildFromLists(this.front__.update(index, item), this.rear__);
  } else {
    return this.buildFromLists(this.front__, this.rear__.update(index, item));
  }
};
/**

*/
mugs.Queue.prototype.removeAt = function(index) {
  if (index <= this.front__.size() - 1) {
    return this.buildFromLists(this.front__.removeAt(index), this.rear__);
  } else {
    return this.buildFromLists(this.front__, this.rear__.removeAt(index));
  }
};
/*
---------------------------------------------------------------------------------------------
Sequenced interface
---------------------------------------------------------------------------------------------
*/
/**
  Returns a mugs.Some with the last item in the collection if it's non-empty.
  otherwise, mugs.None

  @return a mugs.Some with the last item in the collection if it's non-empty.
          otherwise, mugs.None
*/
mugs.Queue.prototype.last = function() {
  if (this.rear__.isEmpty()) {
    return this.front__.last();
  } else {
    return this.rear__.last();
  }
};
/**
  Returns a mugs.Some with the first item in the collection if it's non-empty.
  otherwise, mugs.None

  @return a mugs.Some with the first item in the collection if it's non-empty.
          otherwise, mugs.None
*/
mugs.Queue.prototype.first = function() {
  return this.front__.first();
};
/**
  Returns the first item in the collection. Throws an exception if the collection
  is empty.

  @return The first item in the collection. Throws an exception if the collection
          is empty.
*/
mugs.Queue.prototype.head = function() {
  return this.front__.head();
};
/**
  Return the remainder of the queue after removing the front-most item

  @return The remainder of the queue after removing the front-most item
*/
mugs.Queue.prototype.tail = function() {
  return this.dequeue();
};
/**

*/
mugs.Queue.prototype.foldLeft = function(seed) {
  return __bind(function(f) {
    var partialResult;
    partialResult = this.front__.foldLeft(seed)(f);
    return this.rear__.reverse().foldLeft(partialResult)(f);
  }, this);
};
/**

*/
mugs.Queue.prototype.foldRight = function(seed) {
  return __bind(function(f) {
    var partialResult;
    partialResult = this.front__.foldRight(seed)(f);
    return this.rear__.foldLeft(partialResult)(f);
  }, this);
};
/*
---------------------------------------------------------------------------------------------
Directed interface
---------------------------------------------------------------------------------------------
*/
/**
  Appends an item to the end of the Queue.

  @return A new Queue with item at the end of the Queue
*/
mugs.Queue.prototype.append = function(item) {
  return this.enqueue(item);
};
/**
  Creates a new Stack with the items appended

  @example
  new mugs.Stack([1,2,3]).appendAll([4,5,6]);
  // returns a Stack with the element 1,2,3,4,5,6
  @param  items An array with the items to append to this Stack.
  @return       A new Stack with the items appended
*/
mugs.Queue.prototype.appendAll = function(items) {
  return this.enqueueAll(items);
};
/**
  Creates a new Queue with the item prepended

  @return A new Queue with the items prepended
*/
mugs.Queue.prototype.prepend = function(item) {
  return this.buildFromLists(this.front__.prepend(item), this.rear__);
};
/**
  Creates a new Queue with the items prepended

  @return A new Queue with the items prepended
*/
mugs.Queue.prototype.prependAll = function(items) {
  return this.buildFromLists(this.front__.prependAll(items), this.rear__);
};
/**
  Creates a new Queue with the items in reversed order

  @return A new Queue with the items in reversed order
*/
mugs.Queue.prototype.reverse = function() {
  return this.buildFromLists(this.rear__, this.front__);
};