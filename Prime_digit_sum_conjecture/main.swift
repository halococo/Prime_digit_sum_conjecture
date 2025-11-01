//
//  main.swift
//  Prime-digit-sum-conjecture
//
//  Created by Byul Kang on 2025/11/02.
//

import Foundation

print("═══════════════════════════════════════════════════════════")
print("  Prime Digit Sum Conjecture Verifier")
print("  Base-7 Refined Conjecture Test")
print("  https://github.com/halococo/prime-digit-sum-conjecture")
print("═══════════════════════════════════════════════════════════")
print()

let tester = RefinedConjectureTest()

// Parse command line arguments
if CommandLine.arguments.count > 1 {
    if let limit = Int(CommandLine.arguments[1]) {
        tester.testLimit = limit
        print("Custom test limit: \(limit.formatted())")
        print()
    }
}

tester.start()
