/**
  Implementation of the web-worker part of a parallel set. This is the script that is loaded by
  the webworker and carries out the acctual operations.

  @see {mugs.parallel.Set}
*/var SetWorker;
importScripts("../bin/Mugs.js", "../bin/Option.js", "../bin/Traversable.js", "../bin/List.js", "../bin/LLRedBlackTree.js", "../bin/LLRBSet.js");
SetWorker = function() {};
SetWorker.prototype.map = function(data, f) {
  var result;
  eval("var __evaled__ = " + f);
  result = new mugs.LLRBSet().buildFromArray(data).map(__evaled__).values().asArray();
  return self.postMessage(result);
};
SetWorker.prototype.filter = function(data, f) {
  var result;
  eval("var __evaled__ = " + f);
  result = new mugs.LLRBSet().buildFromArray(data).filter(__evaled__).values().asArray();
  return self.postMessage(result);
};
self.addEventListener('message', function(e) {
  var set;
  set = new SetWorker();
  switch (e.data.operation) {
    case 'map':
      return set.map(e.data.args[0], e.data.args[1]);
    case 'filter':
      return set.filter(e.data.args[0], e.data.args[1]);
    default:
      return self.postMessage("unsopported operation: " + e.data.operation);
  }
});