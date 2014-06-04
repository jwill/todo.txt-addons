fs = require "fs"
path = require 'path'
moment = require 'moment'

{TodoList} = require 'todotxt-coffee/lib/TodoList'

dir = process.argv[2]
if (process.argv.length > 3)
	startDate = moment(process.argv[3], 'YYYY/MM/DD').format('L')
else 
    startDate = moment().startOf('day').subtract('days', 7).format('L')
if (process.argv.length > 4)
	endDate = moment(process.argv[4], 'YYYY/MM/DD').format('L')
else endDate = moment().startOf('day').add('days', 7).format('L')

# Get Done File
todosPast = new TodoList(path.join(dir, 'done.txt'))
todosFuture = new TodoList(path.join(dir, 'todo.txt'))

mit_date_regex = /(20[1-2]{1}[0-9]{1}.[0-9]{2}.[0-9]{2})/
mit_date_regex2 = /({20[1-2]{1}[0-9]{1}.[0-9]{2}.[0-9]{2}})/

work_context_regex = /@work/

mitDate = (task) -> return task.raw().match(mit_date_regex)?[0]
workContext = (task) -> return task.raw().match(work_context_regex)?[0]

getDoneTasks = () -> 
    todos = []
    done_tasks = []
    list_size = todosPast.list.length
    if list_size < 50
        todos = todosPast.list[0..a.length() - 1]
    else 
        todos = todosPast.list[list_size-50..list_size-1]

    for task in todos
        d = moment(task.date().toString().trim()).format('L')
        isWork = workContext(task)
        if startDate <= d and isWork isnt undefined
            done_tasks.push task

    done_tasks

getFutureTasks = () ->
    tasks = []
    for task in todosFuture.list
        date = mitDate(task)
        isWork = workContext(task)
        if date isnt undefined and isWork isnt undefined
            tasks.push(task)
    tasks

parsedDoneTasks = getDoneTasks()
parsedFutureTasks = getFutureTasks()

me = '<REPLACE THIS>'
boss = '<REPLACE THIS>'

stream = fs.createWriteStream("weekly-update-email.txt")
stream.once('open', (fd) ->
    stream.write("from: #{me}\n")
    stream.write("to: #{boss}\n")
    stream.write('subject: Weekly update\n')
    
    stream.write('Last Week:\n\n')
    for p in parsedDoneTasks
        stream.write(p.text()+'\n')

    stream.write('\nNext Week:\n\n')
    for f in parsedFutureTasks
        stream.write(f.raw().replace(mit_date_regex2, '').replace(work_context_regex, '').trim()+'\n')

    stream.end()
    console.log("Write file to weekly-update-email.txt")
)
