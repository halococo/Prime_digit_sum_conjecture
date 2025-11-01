//
//  RefinedConjectureTest.swift
//  Prime-digit-sum-conjecture
//
//  Created by Byul Kang on 2025/11/02.
//  Updated for Refined Conjecture (includes prime powers)
//
import Foundation

class RefinedConjectureTest {

    var testLimit: Int = 10_000_000_000  // Upper limit (configurable)
    let threadCount = ProcessInfo.processInfo.activeProcessorCount

    // MARK: - 1. Primality Test Function
    func isPrime(_ n: Int) -> Bool {
        if n <= 1 { return false }
        if n <= 3 { return true }
        if n % 2 == 0 || n % 3 == 0 { return false }
        var i = 5
        while i * i <= n {
            if n % i == 0 || n % (i + 2) == 0 { return false }
            i += 6
        }
        return true
    }

    // MARK: - 2. Base-7 Digit Sum Function
    func sumOfBase7Digits(_ n: Int) -> Int {
        var num = n
        var sum = 0
        while num > 0 {
            sum += num % 7
            num /= 7
        }
        return sum
    }

    // MARK: - 3. Semiprime Check
    func isSemiprime(_ n: Int) -> Bool {
        if n < 4 { return false }

        var num = n
        var primeFactorCount = 0

        while num % 2 == 0 {
            primeFactorCount += 1
            if primeFactorCount > 2 { return false }
            num /= 2
        }

        var i = 3
        while i * i <= num {
            while num % i == 0 {
                primeFactorCount += 1
                if primeFactorCount > 2 { return false }
                num /= i
            }
            i += 2
        }
        
        if num > 1 {
            primeFactorCount += 1
        }

        return primeFactorCount == 2
    }

    // MARK: - 4. Prime Power Check
    /// Checks if n is a prime power (p^k where p is prime and k >= 1)
    /// Returns true if all prime factors are the same.
    func isPrimePower(_ n: Int) -> Bool {
        if n < 2 { return false }
        if isPrime(n) { return true }  // Prime itself is p^1
        
        var num = n
        var firstPrimeFactor: Int? = nil
        
        // Check factor 2
        if num % 2 == 0 {
            firstPrimeFactor = 2
            while num % 2 == 0 {
                num /= 2
            }
            if num > 1 { return false }
            return true
        }
        
        // Check odd factors
        var i = 3
        while i * i <= num {
            if num % i == 0 {
                if firstPrimeFactor == nil {
                    firstPrimeFactor = i
                } else if firstPrimeFactor != i {
                    return false
                }
                
                while num % i == 0 {
                    num /= i
                }
            }
            i += 2
        }
        
        if num > 1 {
            if firstPrimeFactor == nil {
                return true
            } else {
                return false
            }
        }
        
        return true
    }

    // MARK: - 5. Parallel Execution Function
    func runRefinedConjectureTest(limit: Int, threads: Int) {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "byul.prime.refined.queue", attributes: .concurrent)
        let step = limit / threads
        var violations = [(prime: Int, sum: Int)]()
        let lock = NSLock()

        print("🚀 Starting REFINED Conjecture Test")
        print("   Range: 2 to \(limit.formatted())")
        print("   Threads: \(threads)")
        print("   Testing: S₇(p) ∈ {1, prime, semiprime, prime power}")
        print("   (Progress reports every 10 million numbers)")
        print()
        print("⏳ Computing... (first update may take a moment)")
        print()
        
        let startTime = Date()

        for i in 0..<threads {
            let start = i * step + (i == 0 ? 2 : 1)
            let end = (i == threads - 1) ? limit : start + step - 1

            queue.async(group: group) {
                var localProgress = start
                // Report every 10 million numbers instead of 10% of range
                let progressInterval = 10_000_000
                
                for p in start...end {
                    if self.isPrime(p) {
                        let s7 = self.sumOfBase7Digits(p)
                        
                        // Check refined conjecture
                        if s7 != 1 
                            && !self.isPrime(s7) 
                            && !self.isSemiprime(s7) 
                            && !self.isPrimePower(s7) {
                            
                            lock.lock()
                            violations.append((prime: p, sum: s7))
                            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
                            print("❗️ VIOLATION FOUND")
                            print("   Prime (p)      : \(p)")
                            print("   Digit Sum (S₇) : \(s7)")
                            print("   → S₇ is NOT 1, prime, semiprime, or prime power")
                            
                            // Factorization
                            var factors: [Int] = []
                            var temp = s7
                            var d = 2
                            while d * d <= temp {
                                while temp % d == 0 {
                                    factors.append(d)
                                    temp /= d
                                }
                                d += (d == 2 ? 1 : 2)
                            }
                            if temp > 1 { factors.append(temp) }
                            print("   → \(s7) = \(factors.map(String.init).joined(separator: " × "))")
                            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
                            lock.unlock()
                        }
                    }
                    
                    // Progress reporting - every 10 million numbers
                    if p > start && (p - start) % progressInterval == 0 {
                        let percent = Double(p - start) / Double(end - start) * 100
                        lock.lock()
                        print("   Thread \(i): \(String(format: "%.1f", percent))% (\(p.formatted()))")
                        lock.unlock()
                    }
                }
            }
        }

        group.notify(queue: .main) {
            let duration = Date().timeIntervalSince(startTime)
            print()
            print("═══════════════════════════════════════════════════════════")
            print("🏁 Test Complete")
            print("   Duration: \(String(format: "%.2f", duration)) seconds")
            print("   Range tested: 2 to \(limit.formatted())")
            
            if violations.isEmpty {
                print("   ✅ Result: NO VIOLATIONS FOUND")
                print("   The Refined Conjecture holds for all tested primes.")
            } else {
                print("   ❌ Result: \(violations.count) VIOLATION(S) FOUND")
                print()
                print("   Violations:")
                for (p, s) in violations {
                    print("      p = \(p.formatted()), S₇(p) = \(s)")
                }
            }
            print("═══════════════════════════════════════════════════════════")
            exit(0)
        }
    }

    // MARK: - 6. Execution Entry Point
    func start() {
        runRefinedConjectureTest(limit: testLimit, threads: threadCount)
        RunLoop.main.run()
    }
}
