ListWrapper = require('../src/list')
List        = ListWrapper.List
Cons        = ListWrapper.Cons
Nil         = ListWrapper.Nil

# Small helper method for comparing arrays. Counldn't find
# one in the assert module 
arrEqual = (xs, ys) ->
  if (xs.length == 0 and ys.length == 0)
    true 
  else 
    [x,xRest...] = xs
    [y,yRest...] = ys
    if (x != y) then false else arrEqual(xRest, yRest)

(() -> 
  ###
    Tests that the constructor function works 
    and creates an object with the right structure 
  ###
  list = new List(1,2,3)
  { head: x, tail: { head: x2, tail: { head: x3 }}} = list

  ok (x == 1) is true
  ok (x2 == 2) is true
  ok (x3 == 3) is true
)()

(() -> 
  ###
    Tests that the append method on list actually 
    concatenates the two lists
  ###
  list1 = new List(1,2,3)
  list2 = new List(4,5,6)
  result = list1.append(list2).elements()
  ok arrEqual(result, [1,2,3,4,5,6]) is true
)()

(() -> 
  ###
    Test for foldLeft
  ###
  list = new List(1,2,3,4,5)
  result = list.foldLeft(0)((acc, elem) -> acc + elem )
  ok (result == 15) is true
)()