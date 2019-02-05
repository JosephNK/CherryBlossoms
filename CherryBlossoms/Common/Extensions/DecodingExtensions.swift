//
//  DecodingExtensions.swift
//  JosephNK
//
//  Created by JosephNK on 04/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

extension KeyedDecodingContainer {
    
    /**
     Custom Decode Safe 함수
     - parameters:
     - type: T
     - key: key
     - returns: T
     */
    func decodeSafe<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) throws -> T? {
        let value = try? self.decode(T.self, forKey: key)
        
        if value != nil {
            return value
        }
        
        if let value = try? self.decode(String.self, forKey: key) {
            if T.self is Int.Type {
                return Int(value.isEmpty ? "0" : value) as? T
            } else if T.self is Int64.Type {
                return Int64(value.isEmpty ? "0" : value) as? T
            } else if T.self is Double.Type {
                return Double(value.isEmpty ? "0.0" : value) as? T
            } else if T.self is Float.Type {
                return Float(value.isEmpty ? "0.0" : value) as? T
            }
        }
        
        return nil
    }
    
    /**
     Int64 Decode Safe 함수
     - parameters:
     - key: key
     - returns: Int64 숫자
     */
    func decodeInt64(forKey key: KeyedDecodingContainer.Key) throws -> Int64 {
        if let value = try? self.decode(String.self, forKey: key) {
            return Int64(value.isEmpty ? "0" : value)!
        } else if let value = try? self.decode(Int64.self, forKey: key) {
            return Int64(value)
        } else if let value = try? self.decode(Double.self, forKey: key) {
            return Int64(value)
        } else if let value = try? self.decode(Float.self, forKey: key) {
            return Int64(value)
        }
        return 0
    }
    
    /**
     Double Decode Safe 함수
     - parameters:
     - key: key
     - returns: Double 숫자
     */
    func decodeDouble(forKey key: KeyedDecodingContainer.Key) throws -> Double {
        if let value = try? self.decode(String.self, forKey: key) {
            return Double(value.isEmpty ? "0.0" : value)!
        } else if let value = try? self.decode(Int.self, forKey: key) {
            return Double(value)
        } else if let value = try? self.decode(Double.self, forKey: key) {
            return Double(value)
        } else if let value = try? self.decode(Float.self, forKey: key) {
            return Double(value)
        }
        return 0.0
    }
    
}
