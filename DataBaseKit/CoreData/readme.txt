@objc(Category)
class Category: NSManagedObject {

@NSManaged var recordid: String
...

}


For watching the SQL requests to data base:
-com.apple.CoreData.SQLDebug 1


/*
// Example of filtering and sorting:

let predicate = NSPredicate(format: "title='The first book'")
let lengthSort = NSSortDescriptor(key: "length", ascending: true)
let alphaSort = NSSortDescriptor(key: "text", ascending: false)
fetchRequest.predicate = predicate
fetchRequest.sortDescriptors = [lengthSort, alphaSort]
*/

