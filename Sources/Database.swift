


final public class Orca {

    static var defaultOrca: Orca! = nil

    let driver: Driver

    public init() {
        self.driver = MemoryDriver()
        if Orca.defaultOrca == nil {
            Orca.defaultOrca = self
        }
    }

    public init(driver: Driver) {
        self.driver = driver
        if Orca.defaultOrca == nil {
            Orca.defaultOrca = self
        }
    }
}
