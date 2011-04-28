/**
  @fileoverview Contains the implementation of the List abstract data type.
  @author Mads Hartmann Jensen (mads379@gmail.com)
*/var __slice = Array.prototype.slice, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
mugs.provide('mugs.List');
mugs.require("mugs.Some");
mugs.require("mugs.None");
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
  Methods inherited from mugs.Traversable
  --------------------------------------------------------
  map( f )                                            O(n)
  flatMap( f )                                        O(n)
  filter( f )                                         O(n)
  forEach( f )                                        O(n)
  foldLeft(s)(f)                                      O(n)
  isEmpty()                                           O(1)
  contains( element )                                 O(n)    TODO
  forAll( f )                                         O(n)    TODO
  take( x )                                           O(n)    TODO
  takeWhile( f )                                      O(n)    TODO
  size()                                              O(n)    TODO
  --------------------------------------------------------
  </pre>
  @augments mugs.Traversable
  @class List provides the implementation of the abstract data type List based on a Singly-Linked list
  @public
  @argument items An array of items to construct the List from
*/
mugs.List = function(items) {
  var x, xs;
  if (!(items != null) || items.length === 0) {
    this.head = function() {
      throw new Error("Can't get head of empty List");
    };
    this.tail = function() {
      throw new Error("Can't get tail of empty List");
    };
    this.isEmpty = function() {
      return true;
    };
  } else {
    x = items[0], xs = 2 <= items.length ? __slice.call(items, 1) : [];
    this.head = function() {
      return x;
    };
    this.tail = function() {
      return new mugs.List(xs);
    };
    this.isEmpty = function() {
      return false;
    };
  }
  return this;
};
mugs.List.prototype = new mugs.Traversable();
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
mugs.List.prototype.append = function(element) {
  if (this.isEmpty()) {
    return new mugs.List([element]);
  } else {
    return this.cons(this.head(), this.tail().append(element));
  }
};
/**
  Create a new list by prepending this value
  @param {*} element The element to prepend to the List
  @return {List} A new list containing all the elements of the old list prepended with the element
*/
mugs.List.prototype.prepend = function(element) {
  return this.cons(element, this);
};
/**
  Update the value with the given index.
  @param {number} index The index of the element to update
  @param {*} element The element to replace with the current element
  @return {List} A new list with the updated value.
*/
mugs.List.prototype.update = function(index, element) {
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
  @return {mugs.Some|mugs.None} mugs.Some(element) is it exists, otherwise mugs.None
*/
mugs.List.prototype.get = function(index) {
  if (index < 0 || this.isEmpty()) {
    new mugs.None();
    return new mugs.None();
  } else if (index === 0) {
    return new mugs.Some(this.head());
  } else {
    return this.tail().get(index - 1);
  }
};
/**
  Removes the element at the given index. Runs in O(n) time.
  @param {number} index The index of the element to remove
  @return {List} A new list without the element at the given index
*/
mugs.List.prototype.remove = function(index) {
  if (index === 0) {
    if (!this.tail().isEmpty()) {
      return this.cons(this.tail().first().get(), this.tail().tail);
    } else {
      return new mugs.List();
    }
  } else {
    return this.cons(this.head(), this.tail().remove(index - 1));
  }
};
/**
  The last element in the list
  @return {mugs.Some|mugs.None} mugs.Some(last) if it exists, otherwise mugs.None
*/
mugs.List.prototype.last = function() {
  if (this.tail().isEmpty()) {
    return new mugs.Some(this.head());
  } else {
    return this.tail().last();
  }
};
/**
  The first element in the list
  @return {mugs.Some|mugs.None} mugs.Some(first) if it exists, otherwise mugs.None
*/
mugs.List.prototype.first = function() {
  return new mugs.Some(this.head());
};
/**
  Creates a list by appending the argument list to 'this' list.

  @example
  new mugs.List([1,2,3]).appendList(new mugs.List([4,5,6]));
  // returns a list with the element 1,2,3,4,5,6
  @param {List} list The list to append to this list.
  @return {List} A new list containing the elements of the appended List and the elements of the original List.
*/
mugs.List.prototype.appendList = function(list) {
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
  new mugs.List([4,5,6]).prependList(new mugs.List([1,2,3]));
  // returns a list with the element 1,2,3,4,5,6
  @param {List} list The list to prepend to this list.
  @return {List} A new list containing the elements of the prepended List and the elements of the original List.
*/
mugs.List.prototype.prependList = function(list) {
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
/**
  @private
*/
mugs.List.prototype.buildFromArray = function(arr) {
  return new mugs.List(arr);
};
/**
  Applies function 'f' on each element in the list. This return nothing and is only invoked
  for the side-effects of f.
  @see mugs.Traversable
*/
mugs.List.prototype.forEach = function(f) {
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
   Returns the number of elements in the list
*/
mugs.List.prototype.size = function() {
  var count, xs;
  xs = this;
  count = 0;
  while (!xs.isEmpty()) {
    count += 1;
    xs = xs.tail();
  }
  return count;
};
/**
  Helper method to construct a list from a value and another list
  @private
*/
mugs.List.prototype.cons = function(head, tail) {
  var l;
  l = new mugs.List([head]);
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
  new mugs.List([1,2,3,4,5]).foldLeft(0)(function(acc,current){ acc+current })
  // returns 15 (the sum of the elements in the list)

  @param {*} seed The value to use when the list is empty
  @return {function(function(*, *):*):*} A function which takes a binary function
*/
mugs.List.prototype.foldLeft = function(seed) {
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
/**
  Applies a binary operator on all elements of this list going right to left and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the elements.

  @example
  new mugs.List([1,2,3,4,5]).foldRight(0)(function(acc,current){ acc+current })
  // returns 15 (the sum of the elements in the list)

  @param {*} seed The value to use when the list is empty
  @return {function(function(*, *):*):*} A function which takes a binary function
*/
mugs.List.prototype.foldRight = function(seed) {
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
/**
  Returns a new list with the elements in reversed order.
  @return A new list with the elements in reversed order
*/
mugs.List.prototype.reverse = function() {
  var rest, result;
  result = new mugs.List();
  rest = this;
  while (!rest.isEmpty()) {
    result = result.prepend(rest.head());
    rest = rest.tail();
  }
  return result;
};