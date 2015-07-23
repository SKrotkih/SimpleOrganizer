# SwiftOrganizer
============

This is a simple organizer application for an iPhone and for an iPad. 
Was implemented for getting some practice of using the Swift.

## Implements

Were implemented two types of database:
- Local database on Core Data
- Remote database on the Parse.com server

Also were implemented the following features:
- auto layout (on Interface Builder Level only)
- switching of the database types from Core Data to remote database and vice versa
- used iCloud key-value storage for switching database types (if you change database type on your iPad, then on your iPhone is changing after some seconds too)
- Core Data on iCloud (fallback store)
- push notifications via Parse.com server
- events can be saved to the Calendar (then you can see your events in the Calendar app on your device) by using EventKit.
- localization app 
- local notifications 
- sharing via UIActivityViewController
- UIDocument. Enter and Edit files in the Documents folder.
- Document Picker - access to files on remote storage like iCloud, DropBox and etc with a download to the local Documents folder.
- extension
- today widget
- all database function are in the DataBaseKit.framework.

Were applied the following design patterns:
- abstract method;
- observer;
- singleton;
- builder;

Please pay attention to the following details:
On first start are created some tasks by default. 
You can add a new task by pressing on button '+' on the navigator bar. 
You can select line in table view to start editing current task. 
Any task may be deleted by left swipe gesture on the table view line. 
For fetching tasks are used two tab bar. The upper tab bar is used for filtering by category. The bottom tab bar is used for filtering by icons.

Category - the entity which used for fetching. 
There are some predefined category: 'ToDo', 'Work', 'Life', 'Events'.
Icons are used for fetching too. They are predefined too.

The Project is in progress.
In future:
- add or remove icons and categories
- make login (at present default user and password are used for login to the backend (parse.com server)).
- will be able to add events to the Reminder app
- the local database will be on the iCloud.

## Requirements

- Xcode 6
- iOS 8

## Author

Sergey Krotkih 
http://stackoverflow.com/users/1709337/stosha
https://www.linkedin.com/pub/sergey-krotkih/20/6a4/274
http://sergey-krotkih.blogspot.com

## License

SwiftOrganizer is available under the MIT license. See the LICENSE file for more info.

## Update

16.07.2015: Added task list menu 'Activity'. Have used UIActivityViewController for that. Have made three menu items:  Erase Task, New Task, and Switch DB type.
17.07.2015: Added Sharing Extension
18.07.2015: Added Today Widget
19.07.2015: Created DataBaseKit.framework. All database methods were moved to the framework. All ready to make Today widget with current actual tasks.
20.07.2015: Updated Today Widget (works only with local DataBase). Implemented task list and type of the database switcher