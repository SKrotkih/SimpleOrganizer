# SwiftOrganizer
This is a simple organizer application for iPhone and iPad. 
Was implemented as example of using Swift.

Were realised two type of database:
- Core Data (local database on device)
- Remote database (on Parse.com server)

Features, which were realised:
- autolayout (on Interfase Builder Level only) have done
- switching of the database types from Core Data to remote database and vice versa works
- used iCloud key-value storage for switching database types (if you change database type on your iPad, on your iPhone is changing database type  after some seconds)
- Core Data iCloud (fallback store) works
- push notifications via Parse.com server are working
- events can be saved to the Calendar (then you can see your events in the Calendar app on your device) by EventKit.
- localization 
- local notifications implemented

Used design patterns:
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
In future:
- add or remove icons and categories
- make login (now is used login with default user and password on the parse.com).
- add events to the Reminder app
- Core Data iCloud (backend)
