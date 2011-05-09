###*
  @fileoverview Contains the implementation of the List abstract data type.
  @author Mads Hartmann Jensen (mads379@gmail.com)
### 

mugs.provide('mugs.List')

mugs.require("mugs.Some")
mugs.require("mugs.None")

###*
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
### 
mugs.List = (items) ->

  if not items? || items.length == 0 
    this.head = () -> throw new Error("Can't get head of empty List")
    this.tail = () -> throw new Error("Can't get tail of empty List")
    this.isEmpty = () -> true
  else
    [x, xs...] = items
    this.head = () -> x
    this.tail = () -> new mugs.List(xs)
    this.isEmpty = () -> false
  this

mugs.List.prototype = new mugs.Collection()

###*
  Helper method to construct a list from a value and another list
  
  @private
###

mugs.List.prototype.cons = (head, tail) ->
  l = new mugs.List([head])
  l.tail = () -> tail
  return l

###*
  Applies a binary operator on all elements of this list going left to right and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the elements

  @example
  new mugs.List([1,2,3,4,5]).foldLeft(0)(function(acc,current){ acc+current })
  // returns 15 (the sum of the elements in the list)

  @param {*} seed The value to use when the list is empty
  @return {function(function(*, *):*):*} A function which takes a binary function
###
mugs.List.prototype.foldLeft = (seed) -> (f) =>
  __foldLeft = (acc, xs) ->
    if (xs.isEmpty())
      acc
    else
      __foldLeft( f(acc, xs.head()), xs.tail())
  __foldLeft(seed,this)

###*
  Applies a binary operator on all elements of this list going right to left and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the elements.

  @example
  new mugs.List([1,2,3,4,5]).foldRight(0)(function(acc,current){ acc+current })
  // returns 15 (the sum of the elements in the list)

  @param {*} seed The value to use when the list is empty
  @return {function(function(*, *):*):*} A function which takes a binary function
###
mugs.List.prototype.foldRight = (seed) -> (f) =>
  __foldRight = (xs) ->
    if (xs.isEmpty())
      seed
    else
      f(__foldRight(xs.tail()), xs.head())
  __foldRight(this)

###
---------------------------------------------------------------------------------------------
Collection interface
head(), tail(), and isEmpty() are defined in the constructor 
---------------------------------------------------------------------------------------------
###

###*
  @private
###
mugs.List.prototype.buildFromArray = (arr) ->
  new mugs.List(arr)

###*
  Applies function 'f' on each element in the list. This return nothing and is only invoked
  for the side-effects of f.
  @see mugs.Collection
###
mugs.List.prototype.forEach = ( f ) ->
  if !this.isEmpty()
    f(this.head())
    this.tail().forEach(f)

###
---------------------------------------------------------------------------------------------
Indexed interface
---------------------------------------------------------------------------------------------
###

###*
  Update the value with the given index.
  
  @param  {number}  index   The index of the element to update
  @param  {*}       element The element to replace with the current element
  @return {List}            A new list with the updated value.
###
mugs.List.prototype.update = (index, element) ->
  if index < 0
    throw new Error("Index out of bounds by #{index}")
  else if (index == 0)
    this.cons(element, this.tail())
  else
    this.cons(this.head(), this.tail().update(index-1,element))

###*
  Return an Option containing the nth element in the list.
  
  @param  {number}              index The index of the element to get
  @return {mugs.Some|mugs.None}       mugs.Some(element) is it exists, otherwise mugs.None
###
mugs.List.prototype.get = (index) ->
  if index < 0 || this.isEmpty()
    new mugs.None()
    new mugs.None()
  else if (index == 0)
    new mugs.Some(this.head())
  else
    this.tail().get(index-1)

###*
  Removes the element at the given index. Runs in O(n) time.

  @param  {number} index  The index of the element to remove
  @return {List}          A new list without the element at the given index
###
mugs.List.prototype.removeAt = (index) ->
  if index == 0
    if !this.tail().isEmpty()
      this.cons(this.tail().head(), this.tail().tail())
    else
      new mugs.List()
  else
    this.cons(this.head(), this.tail().removeAt(index-1))

###*
  Returns index of the first element satisfying a predicate, or -1

  @parem  p The predicate to apply to each object
  @return   The index of the first element satisfying a predicate, or -1
###
mugs.List.prototype.findIndexOf = ( p ) -> 
  xs = this 
  index = 0
  while not xs.isEmpty() and not p(xs.head())
    index++
    xs = xs.tail()
    if xs.isEmpty() then index = -1
  index

###
---------------------------------------------------------------------------------------------
Extensible interface
---------------------------------------------------------------------------------------------
###

###*
  Inserts a new item to the end of the List. This is simply calling append. The method is needed
  so a List can be treated as an Extensible collection. runs in O(mugs.List.append)
  
  @param item The item to add to the end of the List
###
mugs.List.prototype.insert = (item) ->
  this.append(item)

###
  Removes an item from the List. Runs in O(n).
  
  @param item The item to remove from the List.
###
mugs.List.prototype.remove = (item) -> 
  if this.isEmpty() 
    this
  else if this.head() == item
    if this.tail().isEmpty() 
      new mugs.List([])
    else 
      this.cons(this.tail().head(), this.tail().tail())
  else
    this.cons(this.head(), this.tail().remove(item))

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
mugs.List.prototype.last = () -> 
  current = this
  if current.isEmpty() 
    return new mugs.None
  while !current.isEmpty()
    item = current.head() 
    current = current.tail()
  return new mugs.Some(item)

###*
  Returns a mugs.Some with the first item in the collection if it's non-empty. 
  otherwise, mugs.None

  @return a mugs.Some with the first item in the collection if it's non-empty. 
          otherwise, mugs.None
###
mugs.List.prototype.first = () -> 
  if this.isEmpty() 
    new mugs.None()
  else
    new mugs.Some(this.head())

###*
  Create a new list by appending this value
  
  @param  {*}     element   The element to append to the List
  @return {List}            A new list containing all the elements of the old with 
                            followed by the element
###
mugs.List.prototype.append = (element) ->
  if (this.isEmpty())
    new mugs.List([element])
  else
    this.cons(this.head(), this.tail().append(element))

###*
  Create a new list by prepending this value
  
  @param  {*}     element   The element to prepend to the List
  @return {List}            A new list containing all the elements of the old list 
                            prepended with the element
###
mugs.List.prototype.prepend = (element) ->
  this.cons(element,this)

###*
  Returns a new list with the elements in reversed order.
  
  @return A new list with the elements in reversed order
###
mugs.List.prototype.reverse = () ->
  result = new mugs.List()
  rest = this
  while (!rest.isEmpty())
    result = result.prepend(rest.head())
    rest = rest.tail()
  result

###*
  Creates a new list with the items appended

  @example
  new mugs.List([1,2,3]).appendAll([4,5,6]);
  // returns a list with the element 1,2,3,4,5,6
  @param  items An array with the items to append to this list.
  @return       A new list with the items appended
###
mugs.List.prototype.appendAll = (items) ->
  if (this.isEmpty())
    new mugs.List(items)
  else
    this.cons(this.head(), this.tail().appendAll(items))

###*
  Creates a new list by copying all of the items in the argument 'list'
  before of 'this' list

  @example
  new mugs.List([4,5,6]).prependAll(new mugs.List([1,2,3]));
  // returns a list with the element 1,2,3,4,5,6
  @param  {List} list The list to prepend to this list.
  @return {List}      A new list containing the elements of the prepended List 
                      and the elements of the original List.
###
mugs.List.prototype.prependAll = (items) ->
  if this.isEmpty()
    new mugs.List(items)
  else
    if items.length == 0 
      this 
    else
      head = items.shift()
      this.cons(head, this.prependAll(items))
