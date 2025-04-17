//
//  DIContainer.swift
//  DebugDemo
//
//  Created by Ruohua Yin on 4/13/25.
//

import Foundation

class DIContainer {
    private var registry: [String: Any] = [:]
    
    func register<Service>(_ type: Service.Type, service: @escaping () -> Service) {
        registry[String(describing: type)] = service
    }
    
    func resolve<Service>(_ type: Service.Type) -> Service {
        let key = String(describing: type)
        guard let serviceClosure = registry[key] as? () -> Service else {
            fatalError("No registration for type \(type)")
        }
        return serviceClosure()
    }
}
