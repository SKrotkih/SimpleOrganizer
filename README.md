# SwiftOrganizer
This is a simple organizer for iPhone. 
It is developed in Swift.
This application is for trying out the new language and new iOS 8 opportunity.  

Database has implemented on two technologies:
- Core Data
- Parse.com
There is possible to switch types (Core Data - Parse.com) in real time.
There are push notifications via Parse.com server.

In design were used the next patterns:
- abstract method;
- observer;
- singleton;

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
For instance, in plan is to add or to remove icons and categories, to make login (at now is used login with default user and password on the parse.com).
