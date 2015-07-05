# SwiftOrganizer
This is a simple organizer application for your iPhone or iPad. 
Was implemented as example of using Swift language at free time.

Were realised two type of database:
- Core Data (local database on device)
- Parse.com (remote database on Parse.com server)

Were realised the next features:
- autolayout (on Interfase Builder Level only)
- switching of the database types from CoreData to remote database and vice versa.
- switching is syncronised by iCloud (you are changing database type on your iPad - on your iPhone database is changing too after some secunds)
- push notifications via Parse.com server.
- events can be saved to the Calendar (then you can see your events in the Calendar app on your device).

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

The Project is in progress.
Is planned:
- add or remove icons and categories
- make login (now is used login with default user and password on the parse.com).
- add events to the Reminder app
