mugs.parallel = {};
mugs.parallel.Set = function(items, comparator) {
  var item, treeUnderConstruction, _i, _len;
  treeUnderConstruction = new mugs.LLRBLeaf();
  if (items instanceof Array && items.length > 0) {
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      treeUnderConstruction = treeUnderConstruction.insert(item, item);
    }
  }
  this.tree = treeUnderConstruction;
  if (comparator != null) {
    this.tree.comparator = comparator;
  }
  return this;
};
mugs.parallel.Set.prototype.map = function(f, callback) {
  var handle, left, leftWorker, right, rightWorker, tree;
  tree = this.tree;
  left = tree.left.map(function(l) {
    return l.values().asArray();
  }).getOrElse([]);
  right = tree.right.map(function(r) {
    return r.values().asArray();
  }).getOrElse([]);
  leftWorker = new Worker('../bin/ParallelSetWorker.js');
  rightWorker = new Worker('../bin/ParallelSetWorker.js');
  handle = {};
  handle.leftMapped = null;
  handle.rightMapped = null;
  leftWorker.addEventListener('message', function(e) {
    return handle.leftMapped = e.data;
  });
  rightWorker.addEventListener('message', function(e) {
    return handle.rightMapped = e.data;
  });
  leftWorker.postMessage({
    'operation': 'map',
    'args': [left, f.toString()]
  });
  rightWorker.postMessage({
    'operation': 'map',
    'args': [right, f.toString()]
  });
  return this.wait(handle, f(tree.value), callback);
};
mugs.parallel.Set.prototype.filter = function() {};
mugs.parallel.Set.prototype.values = function() {
  return this.tree.values();
};
mugs.parallel.Set.prototype.wait = function(handle, piviot, callback) {
  var result, that;
  that = this;
  if ((handle.leftMapped != null) && (handle.rightMapped != null)) {
    result = handle.leftMapped.concat([piviot].concat(handle.rightMapped));
    return callback(new mugs.parallel.Set(result, this.comparator));
  } else {
    return setTimeout(function(){ that.wait(handle,piviot,callback) }, 10);
  }
};