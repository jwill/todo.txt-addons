#!/usr/bin/env groovy
@Grapes(
	@Grab(group='org.fusesource.jansi', module='jansi', version='1.8')
)
import org.fusesource.jansi.AnsiConsole
import static org.fusesource.jansi.Ansi.*
import static org.fusesource.jansi.Ansi.Color.*
/*
		Enhancement of the Lately add-on
		Adds the ability to specify a project

		Arguments:
		1. TODO_DIR
		2. Number of days (optional, default is 7)
		3. Project name (optional)
*/
def dir, days, project

dir = this.args[0]
//Optional
if (this.args.size() > 1)
	days = this.args[1]
else days = 7
if (this.args.size() > 2)
	project = this.args[2]

// Get Done file
def file = new File(dir+File.separator+"done.txt")

def today = new Date().clearTime()
def startDate = today - new Integer(days)

AnsiConsole.systemInstall()
println()
print(ansi().fg(RED).a("Closed tasks since ${startDate.format('yyyy-MM-dd')}"))
if (project != null) 
	print( ansi().a(" for Project: ${project}").reset())
print "\n\n"

file.eachLine {
	def line = it
	// Get date portion
	def date = line.substring(2,12)
	def restOfLine = line - 'x ' - date
	def d = Date.parse('yyyy-MM-dd', date)

	if (startDate <= d && project == null)
		println ansi().fg(GREEN).a(date).fg(YELLOW).a(" "+restOfLine).reset()
	if (startDate <= d && project != null && line.contains(project))
		println ansi().fg(GREEN).a(date).fg(YELLOW).a(" "+restOfLine).reset()
}

AnsiConsole.systemUninstall()
