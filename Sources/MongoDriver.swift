import OrcaMongoDB
import Foundation
import PureJsonSerializer

extension Json {
    init(_ dataType: DataType) {
        switch dataType.dynamicType.valueType {
        case .Double:
             self.init(dataType as! Double)
        case .Int:
             self.init(Double(dataType as! Int))
        case .Float:
            self.init(dataType as! Double)
        case .String:
            self.init(dataType as! String)
        case .Bool:
            self.init(dataType as! Bool)
        }
    }
}

class MongoDriver {

    let mongo: MongoDB

    init() {
        mongo = MongoDB()
    }

    func connect(host: String, port: Int, database: String,
        handler: (error: ErrorProtocol?) -> ()) {
        self.mongo.connect(host: host, port: port, database: database,
            handler: handler)
    }

    func dataTypeFromJson(_ json: [String: Json],
        forSchema schema: Schema) -> [String: DataType] {
            var values = [String: DataType]()

            for (key, value) in json {

                if let object = value.objectValue {
                    //values += dataTypeFromJson(object)
                    if let identifier = object["$oid"]?.stringValue {
                        values[key] = identifier
                    }

                } else if let type = schema[key] {
                    let v: DataType?

                    switch type {
                    case .Double:
                        v = value.doubleValue
                    case .Int:
                        v = value.intValue
                    case .Bool:
                        v = value.boolValue
                    case .Float:
                        v = value.floatValue
                    case .String:
                        v = value.stringValue
                    }
                    values[key] = v
                }
            }

            return values

    }

    func dataTypeFromDocument(_ document: MongoDocument,
        forSchema schema: Schema) -> [String: DataType] {

            guard let data = document.data.objectValue else { return [:] }

            let dataTypes = dataTypeFromJson(data, forSchema: schema)

            return dataTypes
    }

    func mongoDBDocumentData(data: [String: DataType]) -> Json {
        guard let identifier = data["identifier"] as? String else {
            return [:]
        }

        var converted = [String: Json]()

        for (key, value) in data {
            converted[key] = Json(value)
        }

        converted["_id"] = Json(["$oid": Json(identifier)])
        converted["identifier"] = nil
        return Json(converted)
    }

    func parseFiltersToDocument(filters: [Filter]) throws
        -> Json {

        var identifier: String? = nil

        for filter in filters {
            if let filter = filter as? CompareFilter {
                if filter.key == "identifier" {
                    identifier = filter.value.toString()
                }
            }
        }

        guard let id = identifier else {
            throw DriverError.NotFound
        }

        return Json(["_id": Json(["$oid": Json(id)])])
    }
}

extension MongoDriver: Driver {

    func connect(_ url: String, handler: (error: ErrorProtocol?) -> ()) {

    }

    func generateUniqueIdentifier() -> String {
        return MongoDocument.generateObjectId()
    }

    func findOne(collection: String, filters: [Filter],
            schema: Schema) throws -> [String: DataType] {

            guard let database = mongo.database else {
                throw DriverError.NotFound
            }

            let query = try parseFiltersToDocument(filters: filters)

            let collection = MongoCollection(name: collection,
                database: database)

            if let document = try collection.findOne(query) {
                let dataType = dataTypeFromDocument(document,
                    forSchema: schema)
                return dataType
            } else {
                throw DriverError.NotFound
            }
    }

    func find(collection: String, filters: [Filter],
        schema: Schema) throws -> [[String: DataType]] {

            guard let database = mongo.database else {
                throw DriverError.NotFound
            }

            let collection = MongoCollection(name: collection,
                database: database)


            let documents = try collection.find()

            var models = [[String: DataType]]()
            for document in documents {
                let model = dataTypeFromDocument(document,
                    forSchema: schema)
                models.append(model)
            }

            return models

    }

    func update(collection: String, filters: [Filter],
        data: [String: DataType], schema: Schema) throws {

            guard let database = mongo.database else {
                throw DriverError.NotFound
            }

            let collection = MongoCollection(name: collection,
                database: database)

            let query = try parseFiltersToDocument(filters: filters)
            let updateData = mongoDBDocumentData(data: data)
            try collection.update(query, newValue: updateData)
    }

    func insert(collection: String,
        data: [String: DataType], model: Model) throws {

            guard let database = mongo.database else {
                throw DriverError.NotFound
            }

            let converted = mongoDBDocumentData(data: data)

            let collection = MongoCollection(name: collection, database: database)

            let document = try MongoDocument(data: converted)

            try collection.insert(document)

    }

    func delete(collection: String, filters: [Filter],
        schema: Schema) throws {

        guard let database = mongo.database else {
            throw DriverError.NotFound
        }

        let collection = MongoCollection(name: collection,
            database: database)

        let query = try parseFiltersToDocument(filters: filters)

        try collection.remove(query)

    }

}
