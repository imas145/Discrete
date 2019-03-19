//
//  Factorization.swift
//  Arbitrary
//
//  Created by Sami Yrjänheikki on 15/01/2019.
//  Copyright © 2019 Sami Yrjänheikki. All rights reserved.
//

import UIKit

public struct Factorization {
    var factors: [Factor] = []
    let integer: DiscreteInt
    public init(_ integer: DiscreteInt) {
        self.integer = integer
    }
    
    // TODO: Factoring doesn't work for factors >= 11, for example factor(22) = 2, factor(121) = <nothing>
    public mutating func factor() {
        var n = integer
        guard n > 1 else { return }
        guard !n.isPrime else {
            factors.append(Factor(1))
            factors.append(Factor(n))
            return
        }
        let wheel: [DiscreteInt] = [2, 3, 5, 7]
        for k in wheel {
            var count: DiscreteInt = 0
            while n % k == 0 {
                count += 1
                n /= k
            }
            if count > 0 {
                factors.append(Factor(k, count))
            }
        }
        var k: DiscreteInt = 7, i = 1
        let increments: [DiscreteInt] = [4, 2, 4, 2, 6, 2, 6]
        while k * k <= n {
            var count: DiscreteInt = 0
            if n % k == 0 {
                count += 1
                n /= k
            } else {
                if count > 0 {
                    factors.append(Factor(k, count))
                }

                k += increments[i]
                if i < 8 {
                    i += 1
                } else {
                    i = 1
                }
            }
        }
    }
}

extension Factorization: Result {
    public func isEqual(to result: Result) -> Bool {
        if let factorization = result as? Factorization {
            return factors == factorization.factors && integer == factorization.integer
        }
        return false
    }
    
    public var description: String {
        var string = ""
        for factor in factors {
            let superscript = factor.count == 1 ? "" : factor.count.description.superscripted
            string.append(factor.factor.description + superscript + " × ")
        }
        return String(string.dropLast().dropLast().dropLast())
    }
    
    public var isApproximation: Bool {
        return false
    }
    public var signString: String {
        return "="
    }
    
}

public struct Factor: Equatable {
    let factor: DiscreteInt
    let count: DiscreteInt
    public init(_ factor: DiscreteInt, _ count: DiscreteInt) {
        self.factor = factor
        self.count = count
    }
    public init(_ factor: DiscreteInt) {
        self.init(factor, 1)
    }
}
