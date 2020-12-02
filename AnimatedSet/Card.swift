//
//  Card.swift
//  Set
//
//  Created by Federico Veronesi on 21/11/2020.
//

struct Card: Equatable {
    let number: Value
    let shape: Value
    let shading: Value
    let color: Value
    
    init(number: Value, shape: Value, shading: Value, color: Value) {
        self.number = number
        self.shape = shape
        self.shading = shading
        self.color = color
    }
    
    enum Value: Int {
        case first, second, third
        
        static var all = [first, second, third]
    }
}
