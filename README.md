# Prime Digit Sum Conjecture

Computational verification of a refined conjecture about prime number digit sums in base-7.

[![Language](https://img.shields.io/badge/language-Swift-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)](https://www.apple.com/macos/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Overview

This project tests the **Refined Prime Digit Sum Conjecture** for base-7:

> **Conjecture**: For every prime number `p`, the base-7 digit sum `S₇(p)` is one of:
> 1. Equal to 1
> 2. A prime number
> 3. A semiprime (product of exactly two primes, counting multiplicity)
> 4. A prime power (p^k where p is prime and k ≥ 1)

### Background

This conjecture evolved from an earlier version that was elegantly refuted by Davide Lombardo, who found that the prime:
```
p = 7,822,900,281,373,127,764,493
```
has digit sum `S₇(p) = 125 = 5³`. 

The refined conjecture includes **prime powers** (like 5³, 7², 2⁵, etc.) to accommodate such cases, making it substantially more robust than the original.

## Quick Start

### Prerequisites

- **Swift 5.9+** (comes with Xcode on macOS)
- **macOS 14.0+** or **Linux** (Ubuntu 20.04+)
- Multi-core processor (recommended for performance)

### Installation & Compilation

```bash
# Clone the repository
git clone https://github.com/halococo/prime-digit-sum-conjecture.git
cd prime-digit-sum-conjecture

# Compile
swiftc main.swift RefinedConjectureTest.swift -o prime-verifier

# Run (default: test up to 10 billion)
./prime-verifier
```

### Quick Test (Small Range)

```bash
# Test up to 1 million (~1 second)
./prime-verifier 1000000

# Test up to 10 million (~10 seconds)
./prime-verifier 10000000

# Test up to 100 million (~2 minutes)
./prime-verifier 100000000
```

## Usage

### Basic Usage

```bash
# Default: test up to 10¹⁰ (ten billion)
./prime-verifier

# Custom limit: test up to specified number
./prime-verifier <limit>
```

### Examples

```bash
# Quick verification (1 million)
./prime-verifier 1000000

# Medium range (100 million)
./prime-verifier 100000000

# Full verification as in paper (10 billion)
./prime-verifier 10000000000
```

### Expected Runtime

| Range | Approximate Time* |
|-------|------------------|
| 10⁶ (1 million) | ~1 second |
| 10⁷ (10 million) | ~10 seconds |
| 10⁸ (100 million) | ~2 minutes |
| 10⁹ (1 billion) | ~30 minutes |
| 10¹⁰ (10 billion) | **~1 hour** |

*On an 8-core M1 Mac. Times may vary based on CPU.

### Sample Output

```
═══════════════════════════════════════════════════════════
  Prime Digit Sum Conjecture Verifier
  Base-7 Refined Conjecture Test
  https://github.com/halococo/prime-digit-sum-conjecture
═══════════════════════════════════════════════════════════

🚀 Starting REFINED Conjecture Test
   Range: 2 to 10,000,000,000
   Threads: 8
   Testing: S₇(p) ∈ {1, prime, semiprime, prime power}
   (Progress reports every 10 million numbers)

⏳ Computing... (first update may take a moment)

   Thread 0: 0.8% (10,000,002)
   Thread 1: 0.8% (1,260,000,001)
   Thread 2: 0.8% (2,510,000,001)
   ...
   Thread 0: 100.0% (1,250,000,000)
   Thread 7: 100.0% (10,000,000,000)

═══════════════════════════════════════════════════════════
🏁 Test Complete
   Duration: 3847.23 seconds (~64 minutes)
   Range tested: 2 to 10,000,000,000
   ✅ Result: NO VIOLATIONS FOUND
   The Refined Conjecture holds for all tested primes.
═══════════════════════════════════════════════════════════
```

### If Violation Found

If a counterexample is discovered, the output would show:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❗️ VIOLATION FOUND
   Prime (p)      : 123456789
   Digit Sum (S₇) : 275
   → S₇ is NOT 1, prime, semiprime, or prime power
   → 275 = 5 × 5 × 11
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Implementation Details

### Algorithm

1. **Prime Generation**: Iterates through integers, testing primality
2. **Primality Test**: Miller-Rabin style deterministic test for efficiency
3. **Digit Sum**: Converts to base-7 and sums digits
4. **Classification**: Tests if sum is:
   - 1 (trivial case)
   - Prime (using primality test)
   - Semiprime (factorizes and counts prime factors)
   - Prime power (checks if all prime factors are identical)

### Key Functions

```swift
isPrime(n)           // Primality test (Miller-Rabin style)
sumOfBase7Digits(n)  // Computes S₇(n)
isSemiprime(n)       // Checks if n = p₁ × p₂
isPrimePower(n)      // ⭐ NEW: Checks if n = p^k
```

### Performance Optimizations

- **Multi-threading**: Uses all available CPU cores
- **Early exit**: Stops checking factors as soon as conditions fail
- **Progress reporting**: Updates every 10 million numbers
- **Efficient primality**: Trial division up to √n

## Verification Status

✅ **Verified Range**: Up to 10¹⁰ (ten billion)  
✅ **Result**: No counterexamples found  
✅ **Threads**: 8-core parallel execution  
⏱️ **Duration**: ~1 hour on M1 Mac  

## Related Publications

📄 **Academic Papers**:

1. [Original Paper](https://doi.org/10.5281/zenodo.15832754) (July 2025)
   - *On a Sparse Set of Prime Bases with a Unique Digit Sum Property*
   - Status: Refuted by Davide Lombardo

2. [Retraction Note](https://doi.org/10.5281/zenodo.17501191) (November 2025)
   - *Reflections on a Refuted Conjecture: Lessons from a Counterexample*
   - Acknowledges refutation and presents refined version

3. **Refined Conjecture Paper** (November 2025)
   - *On Prime Digit Sums in Base-7: A Refined Conjecture*
   - Link to be added upon publication

## Project Structure

```
prime-digit-sum-conjecture/
├── main.swift                      # Entry point
├── RefinedConjectureTest.swift     # Core testing logic
├── README.md                       # This file
├── LICENSE                         # MIT License
└── .gitignore                      # Git ignore rules
```

## Troubleshooting

### "Command not found: swiftc"

**Solution**: Install Xcode Command Line Tools
```bash
xcode-select --install
```

### Compilation warnings about unused variables

**Solution**: Use the warning-free version or ignore (doesn't affect execution)

### Program seems stuck at 0.0%

**This is normal!** The first progress update appears after processing 10 million numbers, which can take 10-30 seconds depending on your CPU. Just wait.

### Out of memory

**Solution**: Test a smaller range first
```bash
./prime-verifier 10000000  # 10 million instead of 10 billion
```

### Running on Linux

```bash
# Install Swift (Ubuntu/Debian)
sudo apt update
sudo apt install swift

# Compile and run
swiftc main.swift RefinedConjectureTest.swift -o prime-verifier
./prime-verifier
```

## Contributing

Contributions are welcome! Areas for contribution:

- **Extend to other bases** (13, 31, 61, ...)
- **Theoretical analysis** of the digit sum patterns
- **Optimization** of primality testing or factorization
- **Distributed computing** for larger ranges
- **Documentation** improvements

Please open an issue or pull request on GitHub.

## Future Work

1. **Other candidate bases**: Test the conjecture for bases 13, 31, 61, 211, 421
2. **Theoretical proof**: Seek mathematical proof or deeper structural insights
3. **Larger ranges**: Distributed computing for testing beyond 10¹⁰
4. **Heuristic analysis**: Probabilistic estimates of counterexample likelihood
5. **Pattern analysis**: Investigate what makes certain bases "special"

## Theoretical Context

### Why is this conjecture interesting?

1. **Refines a refuted claim**: Shows how mathematical research progresses through iteration
2. **Computational bounds**: Potential counterexamples exist only at enormous scales (≥10³⁸)
3. **Structural mystery**: The set {7, 13, 31, 61, ...} lacks obvious unifying properties
4. **Prime patterns**: Reveals unexpected connections between base representation and factorization

### Known Results

- **Lower bound for counterexamples**: Any violation must have digit sum ≥ 275 = 5² × 11
- **Minimum digits required**: At least 46 base-7 digits (~10³⁸ in decimal)
- **Tested range**: 10¹⁰ with no violations (4 billion primes checked)

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Citation

If you use this code in academic work, please cite:

```bibtex
@software{kang2025prime,
  author = {Kang, Byul},
  title = {Prime Digit Sum Conjecture Verifier},
  year = {2025},
  url = {https://github.com/halococo/prime-digit-sum-conjecture},
  note = {Computational verification of refined conjecture}
}
```

## Author

**Byul Kang**  
Independent Researcher, Republic of Korea  
📧 Email: halococoa@gmail.com  
🔗 ORCID: [0009-0009-0993-4161](https://orcid.org/0009-0009-0993-4161)

---

⭐ **Star this repo** if you find it interesting!  
🐛 **Report issues** on GitHub  
💬 **Discuss** in GitHub Discussions

Last updated: November 2025
