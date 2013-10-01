util = require 'util'
exec = require('child_process').exec
puts = (error, stdout, stderr) ->
  util.puts stdout

paramsSize = process.argv.length

# Get tasks
tasks = process.argv[3...paramsSize]

exec('todo.sh depri '+task, puts) for task in tasks
