# SwiftOrganizer
This is a simple organizer for iPhone. 
Is written in Swift.
I implemented this application for trying out the new language Swift.  

Database is implemented on two technologies:
- Core Data
- Parse.com
There is possible to switch types (Core Data - Parse.com) of the database in real time.

There are push notifications via Parse.com server.

On first start are created some tasks by default. 
You can add a new task by pressing on button '+' on the navigator bar. 
You can select row in tableview for start editing task. 
You can also delete any task by left swipe gesture on the table view row. 
You can make fetch tasks. For that are used two tab bar view. Upper tab bar is used 
for filtering by category. Bottom tab bar is used for filetering by icons.

Category - is the entity which you can use for logical separating tasks. 
There are some predefined category: 'ToDo', 'Work', 'Life', 'Events'.
Some icons are predefined too.

In plan is to give an opportunity for adding or removing their.
