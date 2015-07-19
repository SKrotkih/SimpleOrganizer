# SwiftOrganizer
============

This is a simple organizer application for an iPhone and for an iPad. 
Was implemented for getting some practice of using the Swift.

## Implements

Were realised two types of database:
- Core Data (local database on device)
- Remote database (on Parse.com server)

Features, which were also realised:
- autolayout (on Interfase Builder Level only)
- switching of the database types from Core Data to remote database and vice versa
- used iCloud key-value storage for switching database types (if you change database type on your iPad, then on your iPhone is changing after some seconds too)
- Core Data on iCloud (fallback store)
- push notifications via Parse.com server
- events can be saved to the Calendar (then you can see your events in the Calendar app on your device) by using EventKit.
- localization app 
- local notifications 
- sharing via UIActivityViewController
- UIDocument. Enter and Edit files in the Documents folder.
- Document Picker - access to files on remote storage like iCloud, DropBox and etc with download to local Documents folder.

Used design patterns:
- abstract method;
- observer;
- singleton;
- builder;

Notes for using.
On first start are created some tasks by default. 
You can add a new task by pressing on button '+' on the navigator bar. 
You can select line in tableview to start editing current task. 
Any task may be deleted by left swipe gesture on the table view line. 
For fetching tasks are used two tab bar. Upper tab bar is used for filtering by category. Bottom tab bar is used for filetering by icons.

Category - entity which used for featching. 
There are some predefined category: 'ToDo', 'Work', 'Life', 'Events'.
Icons are used for featching too. They are predefined too.

The Project is in progress.
In future:
- add or remove icons and categories
- make login (now is used login with default user and password on the parse.com).
- add events to the Reminder app
- Core Data on iCloud (backend).

## Requirements

- Xcode 6
- iOS 8

## Author

Sergey Krotkih

## License

SwiftOrganizer is available under the MIT license. See the LICENSE file for more info.

## Update

16.07.2015: Added task list menu 'Activity'. Have used UIActivityViewController for that. Have made three menu items:  Erase Task, New Task and Switch DB type.
17.07.2015: Added Sharing Extension
18.07.2015: Added Today Extension. Widjet
19.07.2015: Created DataBase.framework. All database methods was removed to the framework. All ready to make Today widget with current actual tasks.
