###*
  Implementation of the web-worker part of a parallel set. This is the script that is loaded by 
  the webworker and carries out the acctual operations. 
 
  @see {mugs.parallel.Set}
###


importScripts("../bin/Mugs.js", 
              "../bin/Option.js", 
              "../bin/Traversable.js", 
              "../bin/List.js",
              "../bin/LLRedBlackTree.js",
              "../bin/LLRBSet.js");

SetWorker = () -> 
 
SetWorker.prototype.map = (data,f) -> 
  eval("var __evaled__ = " + f)
  result = new mugs.LLRBSet().buildFromArray(data).map(__evaled__).values().asArray()
  self.postMessage(result) 

SetWorker.prototype.filter = (data, f) -> 
  eval("var __evaled__ = " + f)
  result = new mugs.LLRBSet().buildFromArray(data).filter(__evaled__).values().asArray()
  self.postMessage(result)  

self.addEventListener('message', (e) -> 
  set = new SetWorker()
  switch e.data.operation
    when 'map'     then set.map(e.data.args[0], e.data.args[1])
    when 'filter'  then set.filter(e.data.args[0], e.data.args[1])
    else                self.postMessage("unsopported operation: " + e.data.operation)  
)