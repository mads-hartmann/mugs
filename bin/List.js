/**
  @fileoverview Contains the implementation of the List abstract data type.
  @author Mads Hartmann Jensen (mads379@gmail.com)
*/var List, None, Option, Some, Traversable;
var __slice = Array.prototype.slice, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof require != "undefined" && require !== null) {
  Option = require('./option');
  Some = Option.Some;
  None = Option.None;
  Traversable = (require('./Traversable')).Traversable;
}
/**
  List provides the implementation of the abstract data type List based on a Singly-Linked list. The
  list contains the following operations:

  <pre>
  --------------------------------------------------------
  Core operations of the List ADT
  --------------------------------------------------------
  append( element )                                   O(n)
  prepend( element )                                  O(1)
  update( index, element )                            O(n)
  get( index )                                        O(n)
  remove( index )                                     O(n)
  --------------------------------------------------------
  Methods inherited from mahj.Traversable
  --------------------------------------------------------
  map( f )                                            O(n)
  flatMap( f )                                        O(n)    TODO
  filter( f )                                         O(n)    TODO
  forEach( f )                                        O(n)    TODO
  foldLeft(s)(f)                                      O(n)
  isEmpty()                                           O(1)    TODO
  contains( element )                                 O(n)    TODO
  forAll( f )                                         O(n)    TODO
  take( x )                                           O(n)    TODO
  takeWhile( f )                                      O(n)    TODO
  size()                                              O(n)    TODO
  --------------------------------------------------------
  </pre>
  @augments mahj.Traversable
  @class List provides the implementation of the abstract data type List based on a Singly-Linked list
  @public
*/
List = function() {
  var elements, hd, tl, x, xs;
  elements = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
  x = elements[0], xs = 2 <= elements.length ? __slice.call(elements, 1) : [];
  this.isEmpty = function() {
    return false;
  };
  if (x === void 0 || (x instanceof Array && x.length === 0)) {
    this.head = function() {
      throw new Error("Can't get head of empty List");
    };
    this.tail = function() {
      throw new Error("Can't get tail of empty List");
    };
    this.isEmpty = function() {
      return true;
    };
  } else if (x instanceof Array) {
    hd = x[0], tl = 2 <= x.length ? __slice.call(x, 1) : [];
    this.head = function() {
      return hd;
    };
    this.tail = function() {
      return new List(tl);
    };
  } else {
    this.head = function() {
      return x;
    };
    this.tail = function() {
      return new List(xs);
    };
  }
  return this;
};
List.prototype = new mahj.Traversable();
List.prototype.constructor = List;
/*
---------------------------------------------------------------------------------------------
Methods related to the List ADT
---------------------------------------------------------------------------------------------
*/
/**
  Create a new list by appending this value
  @param {*} element The element to append to the List
  @return {List} A new list containing all the elements of the old with followed by the element
*/
List.prototype.append = function(element) {
  if (this.isEmpty()) {
    return new List(element);
  } else {
    return this.cons(this.head(), this.tail().append(element));
  }
};
/**
  Create a new list by prepending this value
  @param {*} element The element to prepend to the List
  @return {List} A new list containing all the elements of the old list prepended with the element
*/
List.prototype.prepend = function(element) {
  return this.cons(element, this);
};
/**
  Update the value with the given index.
  @param {number} index The index of the element to update
  @param {*} element The element to replace with the current element
  @return {List} A new list with the updated value.
*/
List.prototype.update = function(index, element) {
  if (index < 0) {
    throw new Error("Index out of bounds by " + index);
  } else if (index === 0) {
    return this.cons(element, this.tail());
  } else {
    return this.cons(this.head(), this.tail().update(index - 1, element));
  }
};
/**
  Return an Option containing the nth element in the list.
  @param {number} index The index of the element to get
  @return {Some|None} Some(element) is it exists, otherwise None
*/
List.prototype.get = function(index) {
  if (index < 0 || this.isEmpty()) {
    new None();
    return new None();
  } else if (index === 0) {
    return new Some(this.head());
  } else {
    return this.tail().get(index - 1);
  }
};
/**
  Removes the element at the given index. Runs in O(n) time.
  @param {number} index The index of the element to remove
  @return {List} A new list without the element at the given index
*/
List.prototype.remove = function(index) {
  if (index === 0) {
    if (!this.tail().isEmpty()) {
      return this.cons(this.tail().first().get(), this.tail().tail);
    } else {
      return new List();
    }
  } else {
    return this.cons(this.head(), this.tail().remove(index - 1));
  }
};
/**
  The last element in the list
  @return {Some|None} Some(last) if it exists, otherwise None
*/
List.prototype.last = function() {
  if (this.tail().isEmpty()) {
    return new Some(this.head());
  } else {
    return this.tail().last();
  }
};
/**
  The first element in the list
  @return {Some|None} Some(first) if it exists, otherwise None
*/
List.prototype.first = function() {
  return new Some(this.head());
};
/**
  Creates a list by appending the argument list to 'this' list.

  @example
  new List(1,2,3).appendList(new List(4,5,6));
  // returns a list with the element 1,2,3,4,5,6
  @param {List} list The list to append to this list.
  @return {List} A new list containing the elements of the appended List and the elements of the original List.
*/
List.prototype.appendList = function(list) {
  if (this.isEmpty()) {
    return list;
  } else {
    return this.cons(this.head(), this.tail().appendList(list));
  }
};
/**
  Creates a new list by copying all of the items in the argument 'list'
  before of 'this' list

  @example
  new List(4,5,6).prependList(new List(1,2,3));
  // returns a list with the element 1,2,3,4,5,6
  @param {List} list The list to prepend to this list.
  @return {List} A new list containing the elements of the prepended List and the elements of the original List.
*/
List.prototype.prependList = function(list) {
  if (this.isEmpty()) {
    return list;
  } else {
    if (list.isEmpty()) {
      return this;
    } else {
      return this.cons(list.head(), this.prependList(list.tail()));
    }
  }
};
/*
---------------------------------------------------------------------------------------------
Methods related to Traversable prototype
---------------------------------------------------------------------------------------------
*/
List.prototype.buildFromArray = function(arr) {
  return new List(arr);
};
List.prototype.forEach = function(f) {
  if (!this.isEmpty()) {
    f(this.head());
    return this.tail().forEach(f);
  }
};
/*
---------------------------------------------------------------------------------------------
Miscellaneous Methods
---------------------------------------------------------------------------------------------
*/
/**
  Helper method to construct a list from a value and another list
  @private
*/
List.prototype.cons = function(head, tail) {
  var l;
  l = new List(head);
  l.tail = function() {
    return tail;
  };
  return l;
};
/**
  Applies a binary operator on all elements of this list going left to right and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the elements

  @example
  new List(1,2,3,4,5).foldLeft(0)(function(acc,current){ acc+current })
  // returns 15 (the sum of the elements in the list)

  @param {*} seed The value to use when the list is empty
  @return {function(function(*, *):*):*} A function which takes a binary function
*/
List.prototype.foldLeft = function(seed) {
  return __bind(function(f) {
    var __foldLeft;
    __foldLeft = function(acc, xs) {
      if (xs.isEmpty()) {
        return acc;
      } else {
        return __foldLeft(f(acc, xs.head()), xs.tail());
      }
    };
    return __foldLeft(seed, this);
  }, this);
};
/*
  Applies the function ‘f’ on each element in the collection and returns a new collection with the
  values returned from applying the function ‘f’.

  @param {Function(*)} f The function to apply on each element
  @return A new list with the values of applying the function 'f' on each element
*/
/**
  Applies a binary operator on all elements of this list going right to left and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the elements.

  @example
  new List(1,2,3,4,5).foldRight(0)(function(acc,current){ acc+current })
  // returns 15 (the sum of the elements in the list)

  @param {*} seed The value to use when the list is empty
  @return {function(function(*, *):*):*} A function which takes a binary function
*/
List.prototype.foldRight = function(seed) {
  return __bind(function(f) {
    var __foldRight;
    __foldRight = function(xs) {
      if (xs.isEmpty()) {
        return seed;
      } else {
        return f(__foldRight(xs.tail()), xs.head());
      }
    };
    return __foldRight(this);
  }, this);
};
if (typeof exports != "undefined" && exports !== null) {
  exports.List = List;
}