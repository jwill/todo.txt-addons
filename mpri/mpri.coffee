util = require 'util'
exec = require('child_process').exec
puts = (error, stdout, stderr) ->
	util.puts stdout

paramsSize = process.argv.length

# Get priority and task
priority = process.argv[paramsSize-1]
tasks = process.argv[3...paramsSize-1]

exec('todo.sh pri '+task+' '+priority, puts) for task in tasks
