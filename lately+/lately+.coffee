path = require 'path'
moment = require 'moment'
colors = require 'colors'
{TodoList} = require 'todotxt-coffee/lib/TodoList'

dir = process.argv[2]
if (process.argv.length > 3)
	days = process.argv[3]
else days = 7
if (process.argv.length > 4)
	project = process.argv[4]

# Get Done File
todos = new TodoList(path.join(dir, 'done.txt'))

today = moment().hours(0).minutes(0).seconds(0)
startDate = today.subtract('d',new Number(days))

header = "Closed tasks since #{startDate.format('YYYY-MM-DD')}"
header += " for Project #{project}" if (project isnt undefined)
console.log header.red+'\n'


printTask = (d,r) ->
	console.log d.format('YYYY-MM-DD').green + r.yellow

printTasks = () ->
	if project is undefined
		for task in todos.list
			date = moment(task.date().toString().trim())
			restOfLine = task.raw().substr(12)
	
			printTask(date, restOfLine)	if startDate <= date
	else
      project = '+'+project if project.substring(0,1) != '+'
			tasks = todos.byProject(project)
			for t in tasks
				date = moment(t.date().toString().trim())
				restOfLine = t.raw().substr(12)
				printTask(date, restOfLine) if startDate <= date

printTasks()
