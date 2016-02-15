


final public class Orca {

    static var setDefault = false

    public static var defaultOrca: Orca = Orca()

    public let driver: Driver

    init() {
        self.driver = MemoryDriver()
    }

    public init(driver: Driver) {
        self.driver = driver

        if Orca.setDefault == false {
            Orca.defaultOrca = self
            Orca.setDefault = true
        }
    }
}
