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
- sharing on Facebook and Twitter via SLComposeViewController
- UIDocument. Enter and Edit files in the Documents folder.
- Document Picker - access to files on remote storage like iCloud, DropBox and etc with a download to the local Documents folder.
- extension
- today widget
- all database function are in the DataBaseKit.framework.
- make phone call via FaceTime and by Phone.
- undo for task edit data
- local notifications
- Reachability the Internet observer: auto switch to local data base when the Internet is disconnected
- Observing of changes in Settings app for application's preferences.
- Work with Objective-C in the Swift project
- Cocoapods was added for parse framework 
- Facebook SDK added

Were applied the following design patterns:
- abstract method;
- observer;
- singleton;
- builder;
- chain responsibility;

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
- edit the preferences set for the icons and categories
- make login (at present default user and password are used for login to the backend (parse.com server)).
- the local database will be on the iCloud.

## Requirements

- Xcode 6
- iOS 8

## Author

Sergey Krotkih 
- http://stackoverflow.com/users/1709337/stosha
- https://www.linkedin.com/pub/sergey-krotkih/20/6a4/274
- http://sergey-krotkih.blogspot.com

## License

SwiftOrganizer is available under the MIT license. See the LICENSE file for more info.

## Update

- 16.07.2015: Added task list menu 'Activity'. Have used UIActivityViewController for that. Have made three menu items:  Erase Task, New Task, and Switch DB type.
- 17.07.2015: Added Sharing Extension
- 18.07.2015: Added Today Widget
- 19.07.2015: Created DataBaseKit.framework. All database methods were moved to the framework. All ready to make Today widget with current actual tasks.
- 20.07.2015: Updated Today Widget (works only with local DataBase). Implemented task list and type of the database switcher
- 30.07.2015: Added sharing via SLComposeViewController; added feature to call phone via FaceTime
- 03.08.2015: Implemented undo for task editor view controller
- 04.08.2015: Added feature to make call by Phone
- 07.08.2015: Local notifications for task reminder implemented
- 08.08.2015: Reachability the Internet observer implemented: auto switch to local data base when the Internet is disconnected
- 09.08.2015: If the current database is remote and the Internet is disconnected, then app switches to the local database and goes to the main table. 
- 09.08.2015: Settings app is used for enter some data. Settings changes added observing. 
- 01.09.2015: Fixed "Attempting to badge the application icon but haven't received permission from the user to badge the application" run-time error message
- 03.09.2015: Added Preferences menu. There are a possibility select favorite categories and icons for tab bar.
- 17.09.2015: Fixed build for Xcode 7.0 according Swift 2.0 requirements.
- 19.09.2015: Fixed parse.com framework double linking. Fixed lots of warnings on runtime.
- 29.09.2015: Facebook SDK added, registered AppID, login function in Objective-C was implemented. 
- 02.10.2015: Added the DateTools framework

