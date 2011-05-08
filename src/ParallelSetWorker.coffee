###*
  Implementation of the web-worker part of a parallel set. This is the script that is loaded by 
  the webworker and carries out the actual operations. 
 
  @see {mugs.parallel.Set}
###

SetWorker = () -> 
 
SetWorker.prototype.init = (base) ->
  importScripts("Mugs.js", 
                "Option.js", 
                "Traversable.js", 
                "List.js",
                "LLRedBlackTree.js",
                "LLRBSet.js");

SetWorker.prototype.map = (data,f, msgId) -> 
  eval("var __evaled__ = " + f)
  result = new mugs.LLRBSet().buildFromArray(data).map(__evaled__).values().asArray()
  self.postMessage({ 'result': result, 'msgId' : msgId})  

SetWorker.prototype.filter = (data, f, msgId) -> 
  eval("var __evaled__ = " + f)
  result = new mugs.LLRBSet().buildFromArray(data).filter(__evaled__).values().asArray()
  self.postMessage({ 'result': result, 'msgId' : msgId})  

SetWorker.prototype.flatMap = (data, f, msgId) -> 
  eval("var __evaled__ = " + f)
  result = new mugs.LLRBSet().buildFromArray(data).flatMap(__evaled__).values().asArray()
  self.postMessage({ 'result': result, 'msgId' : msgId})

self.addEventListener('message', (e) -> 
  set = new SetWorker()
  switch e.data.operation
    when 'map'     then set.map(e.data.args[0],     e.data.args[1], e.data.msgId)
    when 'filter'  then set.filter(e.data.args[0],  e.data.args[1], e.data.msgId)
    when 'flatMap' then set.flatMap(e.data.args[0], e.data.args[1], e.data.msgId)
    when 'init'    then set.init(e.data.args[0])
    else                self.postMessage("unsopported operation: " + e.data.operation)  
)