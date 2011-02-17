TreeMap = require('../src/TreeMap').TreeMap

( () -> 
  map = new TreeMap(1, "one").insert(4,"four").insert(2,"two").insert(3,"three").remove(2)
  
  # console.log map
  
  
  
  console.log map.keys()
  # console.log map.values().elements()
  
  console.log map.get(9).getOrElse( "No such value" )
  
)()
