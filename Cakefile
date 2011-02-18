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
	exec("coffee --bare -o bin -c src")