mugs.provide("mugs.Extensible")
mugs.require("mugs.Collection")

###*
  @augments mugs.Collection
###
mugs.Extensible = () -> this

mugs.Extensible.prototype = new mugs.Collection()

###*
  Creates a new collection without any of the given items 
  
  @param items An array with the items to remove from the collection
  @return      A new collection without any of the given items 
###
mugs.Extensible.prototype.removeAll = (items) ->
  newCollection = this
  for item in items
    newCollection = newCollection.remove(item)
  newCollection
  
###*
  Creates a new collection with the items inserted. 
  
  @param items An array with the items to insert into the collection
  @return      A new collection with the items inserted.
###
mugs.Extensible.prototype.insertAll = (items) ->
  newCollection = this
  for item in items
    newCollection = newCollection.insert(item)
  newCollection