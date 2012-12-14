path = require 'path'
sys = require 'sys'
exec = require('child_process').exec

todotxt_path = "~/Dropbox/todo/"

action = null

puts = (error, stdout, stderr) -> sys.puts(stdout)

pull = () ->
	console.log('Pulling files from Google Drive')
	exec("google docs get todo.txt --folder todo --dest #{todotxt_path}todo.txt")
	exec("google docs get done.txt --folder todo --dest #{todotxt_path}done.txt")
	
# Push to Google Drive
push = () ->
	console.log('Pushing files to Google Drive')
	exec("google docs upload #{todotxt_path}todo.txt --folder todo --format txt")
	exec("google docs upload #{todotxt_path}done.txt --folder todo --format txt")


action = process.argv[3]
switch (action)
		when 'push'
			push()
		when 'pull'
			pull()
		when 'help'
			console.log 'TODO: Display help'
		else console.log 'You must specify an action'

