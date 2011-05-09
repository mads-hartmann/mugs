###*

  This is the base file of the mugs library. It declares the mugs namespace and 
  includes support for dynamic dependency management. It is largely inspired by 
  the base.js in both js_cols (jscols.com) and google closure javascript libraries 

  @author Mads Hartmann Jensen (mads379@gmail.com)
### 

###* 
  Global name-space for the entire mugs library 
### 
mugs = {} 

###* 
  A reference to the global object (this is window when executed in a browser)  
### 
mugs.global = this 

###*
  Function to resovle a dependency of another script 
###    
mugs.require = (rule) -> 
  if mugs.getObjectByName(rule)
    return 
  
  path = mugs.getPathFromDeps_(rule)
  if path 
    mugs.included_[path] = true
    mugs.writeScripts_()
  else
    throw Error('mugs.require could not find: ' + rule)

###* 
  Creates the objects stubs for a namespace. When present in a file, mugs.provide
  also indicates that the file defines the indicated object. 
### 
mugs.provide = (name) -> 
  if (mugs.getObjectByName(name) && !mugs.implicitNamespaces_[name]) 
    throw Error('namespace "' + name + '" already declared.')
  
  namespace = name
  while (namespace = namespace.substring(0, namespace.lastIndexOf('.')))
    mugs.implicitNamespaces_[namespace] = true
  
  mugs.exportPath_(name) 

###*
  @private
### 
mugs.implicitNamespaces_ = {}

###*
  Base path for included scripts 
### 
mugs.basePath = ''  

###*
  Tries to detect whether is in the context of an HTML document.
  @return {boolean} True if it looks like HTML document.
  @private
### 
mugs.inHtmlDocument_ = () -> 
  doc = mugs.global.document;
  return typeof doc != 'undefined' and 'write' of doc;  # XULDocument misses write.

###*
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
### 
mugs.exportPath_ = (name, opt_object, opt_objectToExportTo) -> 
  parts = name.split('.')
  cur = opt_objectToExportTo || mugs.global

  # Internet Explorer exhibits strange behavior when throwing errors from
  # methods externed in this manner.  See the testExportSymbolExceptions in
  # base_test.html for an example.
  if not parts[0] of cur and cur.execScript
    cur.execScript('var ' + parts[0])

  # Certain browsers cannot parse code in the form for((a in b); c;);
  # This pattern is produced by the JSCompiler when it collapses the
  # statement above into the conditional loop below. To prevent this from
  # happening, use a for-loop and reserve the init logic as below.
  
  for part in parts 
    if not parts.length and opt_object != undefined
      # last part and we have an object; use it
      cur[part] = opt_object
    else if cur[part]
      cur = cur[part]
    else 
      cur = cur[part] = {}
  return # forcing the coffee compiler to not return anything

###*
  Returns an object based on its fully qualified external name.  If you are
  using a compilation pass that renames property names beware that using this
  function will not find renamed properties.
  
  @param {string} name The fully qualified name.
  @param {Object=} opt_obj The object within which to look; default is
      |mugs.global|.
  @return {Object} The object or, if not found, null.
### 
mugs.getObjectByName = (name, opt_obj) -> 
  parts = name.split('.')
  cur = opt_obj || mugs.global
  for part in parts
    if cur[part]
      cur = cur[part]
    else
      return null 
  return cur 

mugs.included_ = {}

###*
  This object is used to keep track of dependencies and other data that is
  used for loading scripts
  @private
  @type {Object}
### 
mugs.dependencies_ = {
  pathToNames: {}, # 1 to many
  nameToPath: {},  # 1 to 1
  requires: {},    # 1 to many
  # used when resolving dependencies to prevent us from
  # visiting the file twice
  visited: {},
  written: {}  # used to keep track of script files we have written
};

###*
  Adds a dependency from a file to the files it requires.
  @param {string} relPath The path to the js file.
  @param {Array} provides An array of strings with the names of the objects
                          this file provides.
  @param {Array} requires An array of strings with the names of the objects
                          this file requires.
### 
mugs.addDependency = (relPath, provides, requires) ->
  path = relPath.replace(/\\/g, '/')
  deps = mugs.dependencies_
  for provide in provides
    deps.nameToPath[provide] = path;

    if (not (path of deps.pathToNames))
      deps.pathToNames[path] = {};

    deps.pathToNames[path][provide] = true;
    
    for require in requires
      if (not (path of deps.requires))
        deps.requires[path] = {}
      deps.requires[path][require] = true  
  return

###*
  Resolves dependencies based on the dependencies added using addDependency
  and calls importScript_ in the correct order.
  @private
### 
mugs.writeScripts_ = () -> 
  scripts = []
  seenScript = {}
  deps = mugs.dependencies_ 
  
  visitNode = (path) -> 
    if (path of deps.written)
      return
    if path of deps.visited
      if not (path of seenScript)
        seenScript[path] = true
        scripts.push(path) 
      return

    deps.visited[path] = true
  
    if path of deps.requires
      for requireName of deps.requires[path]
        if requireName of deps.nameToPath
          visitNode(deps.nameToPath[requireName])
        else if not mugs.getObjectByName(requireName)
          throw Error('Undefined nameToPath for ' + requireName)
  
    if not (path of seenScript)
      seenScript[path] = true
      scripts.push(path)

  for path of mugs.included_
    if not deps.written[path]
      visitNode(path) 
  
  for script in scripts
    if script 
      mugs.importScript_(mugs.basePath + script)
    else 
      throw Error('Undefined script input');

  return

###*
  Imports a script if, and only if, that script hasn't already been imported.
  (Must be called at execution time)
  @param {string} src Script source.
  @private
### 
mugs.importScript_ = (src) -> 
  importScript = mugs.writeScriptTag_
  if not mugs.dependencies_.written[src] and importScript(src)
    mugs.dependencies_.written[src] = true
  return

###*
  The default implementation of the import function. Writes a script tag to
  import the script.
  
  @param {string} src The script source.
  @return {boolean} True if the script was imported, false otherwise.
  @private
###   
mugs.writeScriptTag_ = (src) -> 
  if mugs.inHtmlDocument_()
    doc = mugs.global.document
    doc.write('<script type="text/javascript" src="' + src + '"></' + 'script>');
    return true
  else 
    return false 

###*
  Looks at the dependency rules and tries to determine the script file that
  fulfills a particular rule.
  @param {string} rule In the form mugs.Class or project.script.
  @return {?string} Url corresponding to the rule, or null.
  @private
### 
mugs.getPathFromDeps_ = (rule) -> 
  if mugs.dependencies_.nameToPath[rule] != undefined
    return mugs.dependencies_.nameToPath[rule]
  else
    return null


###
  --------------------------------------------------------------------------
  Methods related to creating a UID on objects. This is used to deal 
  with hashing due to the lack of a standard hashCode function on 
  objects. 
  --------------------------------------------------------------------------
###

###
  Gets a unique ID for an object. This mutates the object so that further
  calls with the same object as a parameter returns the same value. The unique
  ID is guaranteed to be unique across the current session amongst objects that
  are passed into {@code getUid}. There is no guarantee that the ID is unique
  or consistent across sessions. It is unsafe to generate unique ID for
  function prototypes.
  
  @param {Object} obj The object to get the unique ID for.
  @return {number} The unique ID for the object.
  @public
###
mugs.getUid = (obj) ->
  return obj[mugs.UID_PROPERTY_] ||
      (obj[mugs.UID_PROPERTY_] = ++mugs.uidCounter_);

###
  Removes the unique ID from an object. This is useful if the object was
  previously mutated using {@code mugs.getUid} in which case the mutation is
  undone.
  @param {Object} obj The object to remove the unique ID field from.
  @public
###
mugs.removeUid = (obj) ->
  if 'removeAttribute' of obj
    obj.removeAttribute(mugs.UID_PROPERTY_);
  
  try 
    delete obj[mugs.UID_PROPERTY_];
  catch ex

###
  Name for unique ID property. Initialized in a way to help avoid collisions
  with other closure javascript on the same page.
  @type {string}
  @private
### 
mugs.UID_PROPERTY_ = 'mugs_uid_' +
    Math.floor(Math.random() * 2147483648).toString(36)

###
  Counter for UID.
  @type {number}
  @private
###
mugs.uidCounter_ = 0;


###
  --------------------------------------------------------------------------
  Adding all of the dependencies so it knows which files to include
  --------------------------------------------------------------------------
###

mugs.addDependency("Collection.js", 
                   ["mugs.Collection"], 
                   [])

mugs.addDependency("Option.js", 
                   ["mugs.Some", "mugs.None"],
                   [])

mugs.addDependency("List.js", 
                   ["mugs.List"],
                   ["mugs.Collection"])

mugs.addDependency("Queue.js", 
                   ["mugs.Queue"], 
                   ["mugs.List"]) 

mugs.addDependency("Stack.js", 
                   ["mugs.Stack"], 
                   ["mugs.List"]) 

mugs.addDependency("RedBlackTree.js", 
                   ["mugs.RedBlack", "mugs.RedBlackLeaf", "mugs.RedBlackNode"], 
                   ["mugs.List"])
                   
mugs.addDependency("TreeSet.js", 
                   ["mugs.TreeSet"], 
                   ["mugs.RedBlackLeaf", "mugs.RedBlackNode"])
                   
mugs.addDependency("TreeMap.js", 
                   ["mugs.TreeMap"], 
                   ["mugs.RedBlackLeaf", "mugs.RedBlackNode"])

mugs.addDependency("HashMap.js",
                   ["mugs.HashMap"],
                   ["mugs.List"])
                   
mugs.addDependency("HashSet.js",
                   ["mugs.HashSet"],
                   ["mugs.HashMap"])

mugs.addDependency("LLRedBlackTree.js", 
                   ["mugs.LLRBNode", "mugs.LLRBLeaf"], 
                   ["mugs.List"])
                   
mugs.addDependency("LLRBMap.js", 
                   ["mugs.LLRBMap"], 
                   ["mugs.LLRBNode", "mugs.LLRBLeaf"])
                   
mugs.addDependency("LLRBSet.js", 
                   ["mugs.LLRBSet"], 
                   ["mugs.LLRBNode", "mugs.LLRBLeaf"])

mugs.addDependency("CompleteBinaryTree.js", 
                   ["mugs.CompleteBinaryTree", "mugs.CompleteBinaryTreeNode", "mugs.CompleteBinaryTreeLeaf"], 
                   [])
mugs.addDependency("RandomAccessList.js", 
                   ["mugs.RandomAccessList"], 
                   ["mugs.CompleteBinaryTreeNode", "mugs.CompleteBinaryTreeLeaf", "mugs.List"])

mugs.addDependency("Multimap.js",
                   ["mugs.Multimap"],
                   ["mugs.RedBlackLeaf", "mugs.RedBlackNode"])