import Foundation

/// DI container that lazily resolves dependencies and caches them for reuse.
/// Avoid eager instantiation or preloading—app components rely on this lazy resolution contract,
/// so even future refactors must keep instances lazily initialized.
final class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    /// Dictionary for storing factory closures.
    private var factories: [String: () -> Any] = [:]
    
    /// Dictionary for caching created instances.
    private var instances: [String: Any] = [:]
    
    /// Registers a dependency with a factory closure.
    ///
    /// - Parameters:
    ///   - type: The type of the dependency.
    ///   - name: An optional name to distinguish multiple registrations of the same type.
    ///   - factory: A closure that returns an instance of the dependency.
    /// - Note: If a dependency of this type and name is already registered, the application will terminate.
    func register<Component>(
        type: Component.Type,
        name: String? = nil,
        factory: @escaping () -> Component
    ) {
        let key = makeKey(for: type, name: name)
        guard factories[key] == nil else {
            fatalError("Dependency of type \(Component.self) with name '\(name ?? "nil")' has already been registered.")
        }
        factories[key] = factory
    }
    
    /// Resolves the dependency of the specified type, creating and caching it if needed.
    ///
    /// - Parameters:
    ///   - type: The type of the dependency.
    ///   - name: An optional name used during registration to distinguish the dependency.
    /// - Returns: The resolved dependency.
    /// - Note: If the dependency is not registered or the factory returns an incorrect type, the application will terminate.
    func resolve<Component>(
        type: Component.Type,
        name: String? = nil
    ) -> Component {
        let key = makeKey(for: type, name: name)
        
        if let instance = instances[key] as? Component {
            return instance
        }
        
        guard let factory = factories[key] else {
            fatalError("Dependency of type \(Component.self) with name '\(name ?? "nil")' is not registered.")
        }
        
        guard let instance = factory() as? Component else {
            fatalError("Factory for \(Component.self) with name '\(name ?? "nil")' did not return the correct type.")
        }
        
        instances[key] = instance
        return instance
    }
    
    /// Builds a unique key for storing or retrieving the dependency from internal dictionaries.
    ///
    /// - Parameters:
    ///   - type: The type of the dependency.
    ///   - name: An optional identifier to distinguish multiple dependencies of the same type.
    /// - Returns: A unique key string.
    private func makeKey<Component>(for type: Component.Type, name: String?) -> String {
        if let name {
            return "\(type)-\(name)"
        } else {
            return "\(type)"
        }
    }
}
