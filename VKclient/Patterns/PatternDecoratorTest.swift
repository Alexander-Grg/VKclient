//
//  PatternDecoratorTest.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 27.01.2022.
//

import Foundation

protocol Coffee {
    var cost: Int { get }
}

protocol CoffeeDecorator: Coffee {
    var cost: Int { get }
    init(cost: Coffee)
}

class SimpleCofee: Coffee {
    var cost: Int {
        return 10
    }
    }

class Milk: CoffeeDecorator {
    
    let base: Coffee
    
    var cost: Int {
        return base.cost + 30
    }
    required init(cost: Coffee) {
        self.base = cost
    }
}

class Syrup: CoffeeDecorator {
    
    let base: Coffee
    var cost: Int {
        return base.cost + 50
    }
    
    required init(cost: Coffee) {
        self.base = cost
    }
}

class AdditionalEspresso: CoffeeDecorator {
    let base: Coffee
    var cost: Int {
        return base.cost + 100
    }
    
    required init(cost: Coffee) {
        self.base = cost
    }
}
    
let coffee = SimpleCofee()

let milkCoffee = Milk(cost: coffee)

let coffeeWithSyrupAndMilk = Syrup(cost: milkCoffee)

let coffeeWithSyrupMilkAndEspresso = AdditionalEspresso(cost: coffeeWithSyrupAndMilk)

