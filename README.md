# Orca

![Travis Badge](https://travis-ci.org/elliottminns/orca.svg?branch=master)

A non-blocking I/O, asynchronous ODM. Written in Swift, inspired by Mongoose.

- [x] Powered by [Echo](https://github.com/elliottminns/echo)
- [x] Reflective
- [x] Asynchronous
- [x] Non-blocking
- [x] Beautiful Syntax

## Supported Databases

- SQLite via [Orca-Sqlite](https://github.com/elliottminns/orca-sqlite)

## Getting Started

Orca is easy to set up, just add the following to your `Package.swift` under dependencies

```swift
.Package(url: "https://github.com/elliottminns/orca.git", majorVersion: 0)
```

Saving a model is as simple as:

```swift
import Orca

let simba = Cat(name: "Simba", age: 7)

simba.king = true

simba.save() { error in
    if error == nil {
        print("Roar!")
    }
}
```

That's it!

## Models

To create persistent models, you need to extend from the Orca `Model` protocol.

```swift
Cat.swift
```

```swift
import Orca

class Cat: Model {

    // Required
    var identifier: String?

    static var schema: [String: DataType.Type] {
        return ["name": String.self,
        "age": Int.self,
        "claws": Double.self]
    }

    // User properties
    var name: String
    var age: Int
    var king: Bool?
    var claws: Double?

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    // Required
    required init?(serialized: [String: DataType]) {
        self.identifier = serialized["identifier"] as? String
        self.name = serialized["name"] as! String
        self.age = serialized["age"] as! Int
        self.claws = serialized["claws"] as? Double
    }
}

```

Using reflection, Orca will automatically persist any properties that conform to the DataType protocol.

### Data Types

The current types are supported for automatic persistence:

```swift
String

Int

Double

Float

Bool
```

More will be added in the future.

### Searching for a saved Model.

To search for a saved model, all you need to do is:

```swift
let identifier = ""
Cat.find(identifier) { (model, error) in
    if error == nil {
        print(model?.name)
        print(model?.identifier)
    } else {
        print(error)
    }
}
```

or to retrieve all models of that class

```swift
Cat.findAll() { ([models], error) in
    if error == nil {

        for model in models {
            print(model.name)
        }

    } else {
        print(error)
    }
}
```

### Updating

To update a model, just change the properties you wish, and call save

```swift
simba.king = false

simba.save() { error in
    if error == nil {
        print("Simba is king? \(simba.king)")

        // Simba is king? false
    }
}
```


### Deleting

To delete a model, just call delete on it's instance.

```swift

simba.delete() { error in

    Cat.find(simba.identifier!) { (model, error) in
        print(model)
        // nil
    }

}

```

## Database Drivers

Any database can be supported, provided that a driver has been implemented for it. Orca defaults to a memory driver, which will only persist to the local memory, and will lose it's data once the process is killed.

To set a new driver, just initialize Orca like so:

```swift
Orca(driver: MyDatabaseDriver())
```

### How to create a Driver

To create a database driver, you must extend the `Driver` protocol and implement the required functions.

```swift
import Orca

extension MyDatabaseDriver: Driver {

    public func generateUniqueIdentifier() -> String {
        // Unique ID code
    }

    public func find(collection collection: String, filters: [Filter])
        throws -> [[String: DataType]] {
            // Find code...
    }

    public func findOne(collection collection: String,
        filters: [Filter]) throws -> [String: DataType] {

            // Find one code...

    }

    public func update(collection collection: String, filters: [Filter],
         data: [String : DataType]) throws {
             // Update code...
    }

    public func insert(collection collection: String,
        data: [String: DataType], model: Model) throws {
            // Insert code...
    }

    public func delete (collection collection: String,
        filters: [Filter]) throws {
            // Delete code...
    }
}

```

For a more detailed example, see [orca-sqlite](https://github.com/elliottminns/orca-sqlite) for an Sqlite memory driver implementation.

## Attributions

This project is inspired by [Fluent](https://github.com/tannernelson/fluent) by Tanner Nelson, please go checkout and star his work.
