public enum DatabaseType {
    case Memory
    case Mongo
}

extension DatabaseType {
    var driver: Driver {
        switch self {
            case .Mongo:
                return MongoDriver();
            case .Memory:
                return MemoryDriver();
        }
    }
}


final public class Database {

    static var setDefault = false

    public static var defaultDatabase: Database = Database()

    let type: DatabaseType
    
    let driver: Driver

    init() {
        self.type = .Mongo
        self.driver = DatabaseType.Mongo.driver
    }

    public init(type: DatabaseType) {
        self.type = type
        self.driver = type.driver

        if Database.setDefault == false {
            Database.defaultDatabase = self
            Database.setDefault = true
        }
    }

    public func connect(url: String, handler: (error: ErrorProtocol?) -> ()) {
        driver.connect(url, handler: handler)
    }

    public static func connect(url: String, handler: (error: ErrorProtocol?) -> () {
        defaultDatabase.connect(url: url, handler: handler)
    }
}
