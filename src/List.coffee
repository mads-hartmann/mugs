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
  append(item)                                  O(n)
  prepend(item)                                 O(1)
  update(index, item )                          O(n)
  get(index )                                   O(n)
  remove(index)                                 O(n)
  foldLeft(seed)(f)                             O(n*O(f))
  foldRight(seed)(f)                            O(n*O(f))
  forEach(f)                                    O(n*O(f))
  insert(item)                                  O(n)
  last()                                        O(n)
  first()                                       O(1)
  reverse()                                     O(n)
  appendAll(items)                              O(n)*items
  prependAll(items)                             O(items)
  </pre>
  @public
  @class List provides the implementation of the abstract data type List based on a Singly-Linked list
  @augments mugs.Indexed
  
  @example
  var list = new mugs.List([1,2,3,4,5,6,7,8,9,10]);
  
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

mugs.List.prototype = new mugs.Indexed()

###*
  Helper method to construct a list from a value and another list
  
  @private
###

mugs.List.prototype.cons = (head, tail) ->
  l = new mugs.List([head])
  l.tail = () -> tail
  return l

###*
  Applies a binary operator on all items of this list going left to right and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the items. The function is binary where 
  the first parameter is the value of the fold so far and the second is the current item. 

  @example
  new mugs.List([1,2,3,4,5]).foldLeft(0)(function(acc,current){ return acc+current })
  // returns 15 (the sum of the items in the list)

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
  Applies a binary operator on all items of this list going right to left and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the items. The function is binary where 
  the first parameter is the value of the fold so far and the second is the current item.

  @example
  new mugs.List([1,2,3,4,5]).foldRight(0)(function(acc,current){ return acc+current })
  // returns 15 (the sum of the items in the list)

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
  Applies function 'f' on each value in the collection. This return nothing and is only invoked
  for the side-effects of f.

  @param f The unary function to apply on each element in the collection.
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
  
  @param  {number}  index   The index of the item to update
  @param  {*}       item The item to replace with the current item
  @return {List}            A new list with the updated value.
###
mugs.List.prototype.update = (index, item) ->
  if index < 0
    throw new Error("Index out of bounds by #{index}")
  else if (index == 0)
    this.cons(item, this.tail())
  else
    this.cons(this.head(), this.tail().update(index-1,item))

###*
  Return an Option containing the nth item in the list.
  
  @param  {number}              index The index of the item to get
  @return {mugs.Some|mugs.None}       mugs.Some(item) is it exists, otherwise mugs.None
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
  Removes the item at the given index. Runs in O(n) time.

  @param  {number} index  The index of the item to remove
  @return {List}          A new list without the item at the given index
###
mugs.List.prototype.removeAt = (index) ->
  if index == 0
    if !this.tail().isEmpty()
      this.cons(this.tail().head(), this.tail().tail())
    else
      new mugs.List()
  else
    this.cons(this.head(), this.tail().removeAt(index-1))

###
---------------------------------------------------------------------------------------------
Extensible interface
---------------------------------------------------------------------------------------------
###

###*
  Inserts a new item to the end of the List. Equivalent to append. This is needed so a List can be treated 
  as an Extensible collection. runs in O(mugs.List.append)
  
  @param item The item to add to the end of the List
  @return     A new list with the item appended to the end
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
  
  @param  item      The item to append to the List
  @return           A new list containing all the items of the old with followed by the item
###
mugs.List.prototype.append = (item) ->
  if (this.isEmpty())
    new mugs.List([item])
  else
    this.cons(this.head(), this.tail().append(item))

###*
  Create a new list by prepending this value
  
  @param  {*}     item      The item to prepend to the List
  @return {List}            A new list containing all the items of the old list 
                            prepended with the item
###
mugs.List.prototype.prepend = (item) ->
  this.cons(item,this)

###*
  Returns a new list with the items in reversed order.
  
  @return A new list with the items in reversed order
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
  // returns a list with the item 1,2,3,4,5,6
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
  // returns a list with the items 1,2,3,4,5,6
  @param  {List} list The list to prepend to this list.
  @return {List}      A new list containing the items of the prepended List 
                      and the items of the original List.
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
