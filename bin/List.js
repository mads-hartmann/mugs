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
  Methods inherited from mugs.Collection
  --------------------------------------------------------
  map( f )                                            O(n)
  flatMap( f )                                        O(n)
  filter( f )                                         O(n)
  forEach( f )                                        O(n)
  foldLeft(s)(f)                                      O(n)
  isEmpty()                                           O(1)
  contains( element )                                 O(n)
  forAll( f )                                         O(n)    TODO
  take( x )                                           O(n)    TODO
  takeWhile( f )                                      O(n)    TODO
  size()                                              O(n)    TODO
  --------------------------------------------------------
  </pre>
  @augments mugs.Collection
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
mugs.List.prototype = new mugs.Indexed();
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
/*
---------------------------------------------------------------------------------------------
Collection interface
head(), tail(), and isEmpty() are defined in the constructor
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
  @see mugs.Collection
*/
mugs.List.prototype.forEach = function(f) {
  if (!this.isEmpty()) {
    f(this.head());
    return this.tail().forEach(f);
  }
};
/*
---------------------------------------------------------------------------------------------
Indexed interface
---------------------------------------------------------------------------------------------
*/
/**
  Update the value with the given index.

  @param  {number}  index   The index of the element to update
  @param  {*}       element The element to replace with the current element
  @return {List}            A new list with the updated value.
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

  @param  {number}              index The index of the element to get
  @return {mugs.Some|mugs.None}       mugs.Some(element) is it exists, otherwise mugs.None
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

  @param  {number} index  The index of the element to remove
  @return {List}          A new list without the element at the given index
*/
mugs.List.prototype.removeAt = function(index) {
  if (index === 0) {
    if (!this.tail().isEmpty()) {
      return this.cons(this.tail().head(), this.tail().tail());
    } else {
      return new mugs.List();
    }
  } else {
    return this.cons(this.head(), this.tail().removeAt(index - 1));
  }
};
/**
  Returns mugs.Some(index) of the first element satisfying a predicate, or mugs.None

  @parem  p The predicate to apply to each object
  @return   mugs.Some(index) of the first element satisfying a predicate, or mugs.None
*/
mugs.List.prototype.findIndex = function(p) {
  var index, xs;
  xs = this;
  index = 0;
  while (!xs.isEmpty() && !p(xs.head())) {
    index++;
    xs = xs.tail();
    if (xs.isEmpty()) {
      index = -1;
    }
  }
  if (index === -1) {
    return new mugs.None();
  } else {
    return new mugs.Some(index);
  }
};
/*
---------------------------------------------------------------------------------------------
Extensible interface
---------------------------------------------------------------------------------------------
*/
/**
  Inserts a new item to the end of the List. Equivalent to append. This is needed so a List can be treated
  as an Extensible collection. runs in O(mugs.List.append)

  @param item The item to add to the end of the List
  @return     A new list with the item appended to the end
*/
mugs.List.prototype.insert = function(item) {
  return this.append(item);
};
/*
  Removes an item from the List. Runs in O(n).

  @param item The item to remove from the List.
*/
mugs.List.prototype.remove = function(item) {
  if (this.isEmpty()) {
    return this;
  } else if (this.head() === item) {
    if (this.tail().isEmpty()) {
      return new mugs.List([]);
    } else {
      return this.cons(this.tail().head(), this.tail().tail());
    }
  } else {
    return this.cons(this.head(), this.tail().remove(item));
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
mugs.List.prototype.last = function() {
  var current, item;
  current = this;
  if (current.isEmpty()) {
    return new mugs.None;
  }
  while (!current.isEmpty()) {
    item = current.head();
    current = current.tail();
  }
  return new mugs.Some(item);
};
/**
  Returns a mugs.Some with the first item in the collection if it's non-empty.
  otherwise, mugs.None

  @return a mugs.Some with the first item in the collection if it's non-empty.
          otherwise, mugs.None
*/
mugs.List.prototype.first = function() {
  if (this.isEmpty()) {
    return new mugs.None();
  } else {
    return new mugs.Some(this.head());
  }
};
/**
  Create a new list by appending this value

  @param  {*}     element   The element to append to the List
  @return {List}            A new list containing all the elements of the old with
                            followed by the element
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

  @param  {*}     element   The element to prepend to the List
  @return {List}            A new list containing all the elements of the old list
                            prepended with the element
*/
mugs.List.prototype.prepend = function(element) {
  return this.cons(element, this);
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
/**
  Creates a new list with the items appended

  @example
  new mugs.List([1,2,3]).appendAll([4,5,6]);
  // returns a list with the element 1,2,3,4,5,6
  @param  items An array with the items to append to this list.
  @return       A new list with the items appended
*/
mugs.List.prototype.appendAll = function(items) {
  if (this.isEmpty()) {
    return new mugs.List(items);
  } else {
    return this.cons(this.head(), this.tail().appendAll(items));
  }
};
/**
  Creates a new list by copying all of the items in the argument 'list'
  before of 'this' list

  @example
  new mugs.List([4,5,6]).prependAll(new mugs.List([1,2,3]));
  // returns a list with the element 1,2,3,4,5,6
  @param  {List} list The list to prepend to this list.
  @return {List}      A new list containing the elements of the prepended List
                      and the elements of the original List.
*/
mugs.List.prototype.prependAll = function(items) {
  var head;
  if (this.isEmpty()) {
    return new mugs.List(items);
  } else {
    if (items.length === 0) {
      return this;
    } else {
      head = items.shift();
      return this.cons(head, this.prependAll(items));
    }
  }
};