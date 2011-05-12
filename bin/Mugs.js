/**

  This is the base file of the mugs library. It declares the mugs namespace and
  includes support for dynamic dependency management. It is largely inspired by
  the base.js in both js_cols (jscols.com) and google closure javascript libraries

  @author Mads Hartmann Jensen (mads379@gmail.com)
*/
/**
  Global name-space for the entire mugs library
*/var mugs;
mugs = {};
/**
  A reference to the global object (this is window when executed in a browser)
*/
mugs.global = this;
/**
  Function to resovle a dependency of another script
*/
mugs.require = function(rule) {
  var path;
  if (mugs.getObjectByName(rule)) {
    return;
  }
  path = mugs.getPathFromDeps_(rule);
  if (path) {
    mugs.included_[path] = true;
    return mugs.writeScripts_();
  } else {
    throw Error('mugs.require could not find: ' + rule);
  }
};
/**
  Creates the objects stubs for a namespace. When present in a file, mugs.provide
  also indicates that the file defines the indicated object.
*/
mugs.provide = function(name) {
  var namespace;
  if (mugs.getObjectByName(name) && !mugs.implicitNamespaces_[name]) {
    throw Error('namespace "' + name + '" already declared.');
  }
  namespace = name;
  while ((namespace = namespace.substring(0, namespace.lastIndexOf('.')))) {
    mugs.implicitNamespaces_[namespace] = true;
  }
  return mugs.exportPath_(name);
};
/**
  @private
*/
mugs.implicitNamespaces_ = {};
/**
  Base path for included scripts
*/
mugs.basePath = '';
/**
  Tries to detect whether is in the context of an HTML document.
  @return {boolean} True if it looks like HTML document.
  @private
*/
mugs.inHtmlDocument_ = function() {
  var doc;
  doc = mugs.global.document;
  return typeof doc !== 'undefined' && 'write' in doc;
};
/**
  Builds an object structure for the provided namespace path,
  ensuring that names that already exist are not overwritten. For
  example:
  "a.b.c" -> a = {};a.b={};a.b.c={};
  Used by mugs.provide and mugs.exportSymbol.
  @param {string} name name of the object that this file defines.
  @param {*=} opt_object the object to expose at the end of the path.
  @param {Object=} opt_objectToExportTo The object to add the path to; default
      is |mugs.global|.
  @private
*/
mugs.exportPath_ = function(name, opt_object, opt_objectToExportTo) {
  var cur, part, parts, _i, _len;
  parts = name.split('.');
  cur = opt_objectToExportTo || mugs.global;
  if (!parts[0] in cur && cur.execScript) {
    cur.execScript('var ' + parts[0]);
  }
  for (_i = 0, _len = parts.length; _i < _len; _i++) {
    part = parts[_i];
    if (!parts.length && opt_object !== void 0) {
      cur[part] = opt_object;
    } else if (cur[part]) {
      cur = cur[part];
    } else {
      cur = cur[part] = {};
    }
  }
};
/**
  Returns an object based on its fully qualified external name.  If you are
  using a compilation pass that renames property names beware that using this
  function will not find renamed properties.

  @param {string} name The fully qualified name.
  @param {Object=} opt_obj The object within which to look; default is
      |mugs.global|.
  @return {Object} The object or, if not found, null.
*/
mugs.getObjectByName = function(name, opt_obj) {
  var cur, part, parts, _i, _len;
  parts = name.split('.');
  cur = opt_obj || mugs.global;
  for (_i = 0, _len = parts.length; _i < _len; _i++) {
    part = parts[_i];
    if (cur[part]) {
      cur = cur[part];
    } else {
      return null;
    }
  }
  return cur;
};
mugs.included_ = {};
/**
  This object is used to keep track of dependencies and other data that is
  used for loading scripts
  @private
  @type {Object}
*/
mugs.dependencies_ = {
  pathToNames: {},
  nameToPath: {},
  requires: {},
  visited: {},
  written: {}
};
/**
  Adds a dependency from a file to the files it requires.
  @param {string} relPath The path to the js file.
  @param {Array} provides An array of strings with the names of the objects
                          this file provides.
  @param {Array} requires An array of strings with the names of the objects
                          this file requires.
*/
mugs.addDependency = function(relPath, provides, requires) {
  var deps, path, provide, require, _i, _j, _len, _len2;
  path = relPath.replace(/\\/g, '/');
  deps = mugs.dependencies_;
  for (_i = 0, _len = provides.length; _i < _len; _i++) {
    provide = provides[_i];
    deps.nameToPath[provide] = path;
    if (!(path in deps.pathToNames)) {
      deps.pathToNames[path] = {};
    }
    deps.pathToNames[path][provide] = true;
    for (_j = 0, _len2 = requires.length; _j < _len2; _j++) {
      require = requires[_j];
      if (!(path in deps.requires)) {
        deps.requires[path] = {};
      }
      deps.requires[path][require] = true;
    }
  }
};
/**
  Resolves dependencies based on the dependencies added using addDependency
  and calls importScript_ in the correct order.
  @private
*/
mugs.writeScripts_ = function() {
  var deps, path, script, scripts, seenScript, visitNode, _i, _len;
  scripts = [];
  seenScript = {};
  deps = mugs.dependencies_;
  visitNode = function(path) {
    var requireName;
    if (path in deps.written) {
      return;
    }
    if (path in deps.visited) {
      if (!(path in seenScript)) {
        seenScript[path] = true;
        scripts.push(path);
      }
      return;
    }
    deps.visited[path] = true;
    if (path in deps.requires) {
      for (requireName in deps.requires[path]) {
        if (requireName in deps.nameToPath) {
          visitNode(deps.nameToPath[requireName]);
        } else if (!mugs.getObjectByName(requireName)) {
          throw Error('Undefined nameToPath for ' + requireName);
        }
      }
    }
    if (!(path in seenScript)) {
      seenScript[path] = true;
      return scripts.push(path);
    }
  };
  for (path in mugs.included_) {
    if (!deps.written[path]) {
      visitNode(path);
    }
  }
  for (_i = 0, _len = scripts.length; _i < _len; _i++) {
    script = scripts[_i];
    if (script) {
      mugs.importScript_(mugs.basePath + script);
    } else {
      throw Error('Undefined script input');
    }
  }
};
/**
  Imports a script if, and only if, that script hasn't already been imported.
  (Must be called at execution time)
  @param {string} src Script source.
  @private
*/
mugs.importScript_ = function(src) {
  var importScript;
  importScript = mugs.writeScriptTag_;
  if (!mugs.dependencies_.written[src] && importScript(src)) {
    mugs.dependencies_.written[src] = true;
  }
};
/**
  The default implementation of the import function. Writes a script tag to
  import the script.

  @param {string} src The script source.
  @return {boolean} True if the script was imported, false otherwise.
  @private
*/
mugs.writeScriptTag_ = function(src) {
  var doc;
  if (mugs.inHtmlDocument_()) {
    doc = mugs.global.document;
    doc.write('<script type="text/javascript" src="' + src + '"></' + 'script>');
    return true;
  } else {
    return false;
  }
};
/**
  Looks at the dependency rules and tries to determine the script file that
  fulfills a particular rule.
  @param {string} rule In the form mugs.Class or project.script.
  @return {?string} Url corresponding to the rule, or null.
  @private
*/
mugs.getPathFromDeps_ = function(rule) {
  if (mugs.dependencies_.nameToPath[rule] !== void 0) {
    return mugs.dependencies_.nameToPath[rule];
  } else {
    return null;
  }
};
/*
  --------------------------------------------------------------------------
  Methods related to creating a UID on objects. This is used to deal
  with hashing due to the lack of a standard hashCode function on
  objects.
  --------------------------------------------------------------------------
*/
/*
  Gets a unique ID for an object. This mutates the object so that further
  calls with the same object as a parameter returns the same value. The unique
  ID is guaranteed to be unique across the current session amongst objects that
  are passed into {@code getUid}. There is no guarantee that the ID is unique
  or consistent across sessions. It is unsafe to generate unique ID for
  function prototypes.

  @param {Object} obj The object to get the unique ID for.
  @return {number} The unique ID for the object.
  @public
*/
mugs.getUid = function(obj) {
  return obj[mugs.UID_PROPERTY_] || (obj[mugs.UID_PROPERTY_] = ++mugs.uidCounter_);
};
/*
  Removes the unique ID from an object. This is useful if the object was
  previously mutated using {@code mugs.getUid} in which case the mutation is
  undone.
  @param {Object} obj The object to remove the unique ID field from.
  @public
*/
mugs.removeUid = function(obj) {
  if ('removeAttribute' in obj) {
    obj.removeAttribute(mugs.UID_PROPERTY_);
  }
  try {
    return delete obj[mugs.UID_PROPERTY_];
  } catch (ex) {

  }
};
/*
  Name for unique ID property. Initialized in a way to help avoid collisions
  with other closure javascript on the same page.
  @type {string}
  @private
*/
mugs.UID_PROPERTY_ = 'mugs_uid_' + Math.floor(Math.random() * 2147483648).toString(36);
/*
  Counter for UID.
  @type {number}
  @private
*/
mugs.uidCounter_ = 0;
/*
  --------------------------------------------------------------------------
  Adding all of the dependencies so it knows which files to include
  --------------------------------------------------------------------------
*/
mugs.addDependency("Collection.js", ["mugs.Collection"], []);
mugs.addDependency("Extensible.js", ["mugs.Extensible"], ["mugs.Collection"]);
mugs.addDependency("Indexed.js", ["mugs.Indexed"], ["mugs.Extensible"]);
mugs.addDependency("Option.js", ["mugs.Some", "mugs.None"], []);
mugs.addDependency("List.js", ["mugs.List"], ["mugs.Collection"]);
mugs.addDependency("Queue.js", ["mugs.Queue"], ["mugs.List"]);
mugs.addDependency("Stack.js", ["mugs.Stack"], ["mugs.List"]);
mugs.addDependency("RedBlackTree.js", ["mugs.RedBlack", "mugs.RedBlackLeaf", "mugs.RedBlackNode"], ["mugs.List"]);
mugs.addDependency("TreeSet.js", ["mugs.TreeSet"], ["mugs.RedBlackLeaf", "mugs.RedBlackNode"]);
mugs.addDependency("TreeMap.js", ["mugs.TreeMap"], ["mugs.RedBlackLeaf", "mugs.RedBlackNode"]);
mugs.addDependency("HashMap.js", ["mugs.HashMap"], ["mugs.List"]);
mugs.addDependency("HashSet.js", ["mugs.HashSet"], ["mugs.HashMap"]);
mugs.addDependency("LLRedBlackTree.js", ["mugs.LLRBNode", "mugs.LLRBLeaf"], ["mugs.List"]);
mugs.addDependency("LLRBMap.js", ["mugs.LLRBMap"], ["mugs.LLRBNode", "mugs.LLRBLeaf"]);
mugs.addDependency("LLRBSet.js", ["mugs.LLRBSet"], ["mugs.LLRBNode", "mugs.LLRBLeaf"]);
mugs.addDependency("CompleteBinaryTree.js", ["mugs.CompleteBinaryTree", "mugs.CompleteBinaryTreeNode", "mugs.CompleteBinaryTreeLeaf"], []);
mugs.addDependency("RandomAccessList.js", ["mugs.RandomAccessList"], ["mugs.CompleteBinaryTreeNode", "mugs.CompleteBinaryTreeLeaf", "mugs.List"]);
mugs.addDependency("Multimap.js", ["mugs.Multimap"], ["mugs.RedBlackLeaf", "mugs.RedBlackNode"]);