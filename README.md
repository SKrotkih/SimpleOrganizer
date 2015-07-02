# SwiftOrganizer
This is a simple organizer application for iPhone. 
It is developed in Swift.
Was implemented just for example of using Swift.

Were realised two type of database:
- Core Data (local database on SQLite)
- Parse.com (remote database on Parse.com server)

Were realised the next features:
- switching of the database types from CoreData to Parse.com remote database and vice versa in real time.
- push notifications via Parse.com server.
- events can be saved to the Calendar.

Were used next design patterns:
- abstract method;
- observer;
- singleton;
- builder;

On first start are created some tasks by default. 
You can add a new task by pressing on button '+' on the navigator bar. 
You can select row in tableview for start editing task. 
You can also delete any task by left swipe gesture on the table view row. 
You can make fetch tasks. For that are used two tab bar view. Upper tab bar is used 
for filtering by category. Bottom tab bar is used for filetering by icons.

Category - is the entity which you can use for logical separating tasks. 
There are some predefined category: 'ToDo', 'Work', 'Life', 'Events'.
Some icons are predefined too.

The Project is in progressing.
For instance, in plan is to add or to remove icons and categories, to make login (at now is used login with default user and password on the parse.com).
