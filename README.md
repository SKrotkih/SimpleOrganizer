# SwiftOrganizer
============

This is an organizer application in Swift for both iPhone and iPad. 

## Implements

Was used VIPER approach architecture.

There were implemented two types of database:
- Local database on Core Data
- Remote database on the Parse.com server

The following features has been implemented:
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
- Facebook SDK was added
- Log In to loacal database implemented via Facebook 
- Log In to remote data base implemented by the Parse.com SDK
- migration data after changing data model 
- multi tasking is ready
- Google Analitics
- Crashlitics
- implemented according Uncle Bob's clean architecture requarements

Were applied the following design patterns:
- abstract method;
- observer;
- singleton;
- builder;
- filter;
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

## WEB site the app

http://thebestplace.krizantos.com/SO/

## Requirements

- Xcode 6 or later
- iOS 8 or later

## Author

Sergey Krotkih 
- http://stackoverflow.com/users/1709337/stosha
- https://www.linkedin.com/pub/sergey-krotkih/20/6a4/274
- http://sergey-krotkih.blogspot.com

## License

SwiftOrganizer is available under the MIT license. See the LICENSE file for more info.

## Update

- 16.07.2015: Task list menu 'Activity' is added. Have used UIActivityViewController for that. Have made three menu items:  Erase Task, New Task, and Switch DB type.
- 17.07.2015: Sharing Extension added.
- 18.07.2015: Today Widget added.
- 19.07.2015: DataBaseKit.framework is created. All database methods are moved to the framework. All ready for making Today widget with current actual tasks.
- 20.07.2015: Today Widget (works only with local DataBase) updated. Task list and type of the database switcher is implemented.
- 30.07.2015: Sharing via SLComposeViewController and feature to call phone via FaceTime are added
- 03.08.2015: Undo for task editor view controller is implemented.
- 04.08.2015: Feature to make call by Phone is added.
- 07.08.2015: Local notifications for task reminder implemented
- 08.08.2015: Reachability the Internet observer implemented: auto switch to local data base when the Internet is disconnected
- 09.08.2015: If the current database is in remote mode and the Internet is disconnected, then app switches to the local database and goes to the main table at now. 
- 09.08.2015: Settings app is used for enter some data. Settings changes added to observing. 
- 01.09.2015: "Attempting to badge the application icon but haven't received permission from the user to badge the application" run-time error message is fixed
- 03.09.2015: Preferences menu is added. There are a possibility select favorite categories and icons for the tabbar.
- 17.09.2015: Build for Xcode 7.0 according Swift 2.0 requirements is fixed.
- 19.09.2015: Parse.com framework double linking and a lot of warnings on tuntime are fixed.
- 29.09.2015: Facebook SDK is added, AppID is registered, login function in Objective-C is implemented. 
- 02.10.2015: DateTools framework is added.
- 07.10.2015: Log In to the local database fia Facebook is implemented. Database for local user in a different storage  is implemented.
- 12.10.2015: Data migration for core data for new model data implemented. 
- 17.10.2015: The Local Database is normalized.
- 14.05.2016: Google Analytics is added.
- 14.05.2016: Crashlitics added.
- 12.06.2016: Was partially reorganized "User" use case according of the VIPER architecture requirements  
- 14.06.2016: "Login" use case reorganized according to the VIPER architecture requirements
- 17.06.2016: Redesign ListTasksViewController according the Uncle Bob's clean architecture
