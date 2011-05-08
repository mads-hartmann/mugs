# ===============================================================
# Bachelorproject
#
# A lot from this file has been copied from the original 
# coffeescript cakefile 
#
# @author Mads Hartmann Jensen 
# ===============================================================


CoffeeScript  = require './lib/coffee-script'
{spawn, exec} = require 'child_process'

task 'build', 'build source', () -> 
	exec("coffee -c -b -o bin/ src/", (err, stdout, stderr) ->
    throw Error(err) if err
    console.log stdout + stderr)
	  
task 'jscoverage', 'instruments the source code for JSCoverage and start the JSCoverage server', () ->
  console.log """Started JSCoverage server at: http://127.0.0.1:8080/jscoverage.html?test/index.html
                 Hit CTRL+C to stop"""
  exec('jscoverage-server --no-instrument=/test/ --verbose --ip-address=0.0.0.0 --port=8080')
  
task 'api-doc', 'Create API documentation', () -> 
  exec("""java -jar /Users/Mads/dev/tools/jsdoc-toolkit/jsrun.jar /Users/Mads/dev/tools/jsdoc-toolkit/app/run.js -a -t=jsdoc-templates -d=api/ bin""", (err, stdout, stderr) ->
    throw Error(err) if err
    console.log stdout + stderr)
  
  