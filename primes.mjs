/**
 * Prime number utility library.
 * Provides functions for checking prime numbers, generating prime lists, and iterating over primes efficiently.
 * Uses **caching** and **Sieve of Eratosthenes** for performance optimization.
 * @module primes
 */

/**
 * A **list** of cached prime numbers, starting with `2`.
 * This array stores previously computed prime numbers to avoid redundant calculations.
 * @constant {number[]}
 */
let cachedPrimes = [2];

/**
 * A **Set** for fast lookup of known prime numbers.
 * Storing primes in a `Set` allows O(1) lookups when checking for primality.
 * @constant {Set<number>}
 */
let primeSet = new Set(cachedPrimes);

/**
 * Asynchronously checks whether a given number `n` is prime.
 *
 * ### Algorithm:
 * - If `n` is in the cache (`primeSet`), it is instantly returned as prime.
 * - If `n` is even and not `2`, it is not prime.
 * - Otherwise, trial division is performed up to `√n` to determine primality.
 * - If `n` is found to be prime, it is added to the cache.
 *
 * **Time Complexity:** _O(√n)_ worst-case
 *
 * @async
 * @param {number} n - The number to check. Must be an integer ≥ 0.
 * @returns {Promise<boolean>} Resolves to `true` if `n` is prime, otherwise `false`.
 * @throws {TypeError} If `n` is not a valid integer ≥ 0.
 * @example
 * console.log(await isPrime(11)); // true
 * console.log(await isPrime(15)); // false
 */
export async function isPrime(n) {
    if (!Number.isInteger(n) || n < 0) {
        throw new TypeError("Input must be an integer ≥ 0.");
    }
    if (n === 0 || n === 1) return false;
    if (primeSet.has(n)) return true;

    if (n % 2 === 0) return n === 2;

    let d = 3;
    while (d * d <= n) {
        if (n % d === 0) return false;
        d += 2;
    }

    cachedPrimes.push(n);
    primeSet.add(n);
    return true;
}

/**
 * Computes all prime numbers up to `n` using the **Sieve of Eratosthenes**.
 *
 * ### Algorithm:
 * - A boolean array (`sieve`) is created where `true` means "prime candidate."
 * - Starting from `2`, all multiples of known primes are marked as non-prime.
 * - The algorithm runs in **O(n log log n)** time, making it efficient for large `n`.
 * - If the cache already contains primes ≤ `n`, only new primes are computed.
 *
 * @async
 * @param {number} n - The upper limit for prime computation. Must be an integer ≥ 0.
 * @returns {Promise<number[]>} Resolves to an array of all prime numbers ≤ `n`.
 * @throws {TypeError} If `n` is not a valid integer ≥ 0.
 * @example
 * console.log(await getPrimes(30)); // [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
 */
export async function getPrimes(n) {
    if (!Number.isInteger(n) || n < 0) {
        throw new TypeError("Input must be an integer ≥ 0.");
    }

    let lastCachedPrime = cachedPrimes[cachedPrimes.length - 1];

    if (lastCachedPrime < n) {
        let sieve = Array(n + 1).fill(true);
        sieve[0] = sieve[1] = false;

        for (let p = 2; p * p <= n; p++) {
            if (sieve[p]) {
                for (let multiple = p * p; multiple <= n; multiple += p) {
                    sieve[multiple] = false;
                }
            }
        }

        for (let i = lastCachedPrime + 1; i <= n; i++) {
            if (sieve[i] && !primeSet.has(i)) {
                cachedPrimes.push(i);
                primeSet.add(i);
            }
        }
    }

    return cachedPrimes.filter(prime => prime <= n);
}

/**
 * A **generator function** that yields prime numbers sequentially.
 *
 * ### Behavior:
 * - First, it **yields primes from the cache** (`cachedPrimes`).
 * - If more primes are needed, it **computes new ones indefinitely**.
 * - New primes are stored in the cache to optimize future iterations.
 *
 * **Time Complexity:**  
 * - O(1) per cached prime.  
 * - O(√n) for new prime calculations.
 *
 * @generator
 * @yields {number} The next prime number in sequence.
 * @example
 * const generator = iterPrimes();
 * console.log(generator.next().value); // 2
 * console.log(generator.next().value); // 3
 * console.log(generator.next().value); // 5
 */
export function* iterPrimes() {
    let index = 0;
    let current = cachedPrimes[cachedPrimes.length - 1];

    while (index < cachedPrimes.length) yield cachedPrimes[index++];

    while (true) {
        while (!isPrimeSync(current)) {
            current++;
        }
        if (!primeSet.has(current)) {
            cachedPrimes.push(current);
            primeSet.add(current);
        }
        yield current;
        current++;
    }
}

/**
 * A **synchronous** version of `isPrime()`, used by the generator `iterPrimes()`.
 *
 * ### Algorithm:
 * - If `n` is in the cache, return `true` immediately.
 * - Otherwise, perform trial division up to `√n` to determine primality.
 * - This function is used for synchronous prime generation.
 *
 * **Time Complexity:** _O(√n)_ worst-case
 *
 * @param {number} n - The number to check. Must be an integer ≥ 0.
 * @returns {boolean} `true` if `n` is prime, otherwise `false`.
 * @throws {TypeError} If `n` is not a valid integer ≥ 0.
 * @example
 * console.log(isPrimeSync(7)); // true
 * console.log(isPrimeSync(12)); // false
 */
function isPrimeSync(n) {
    if (!Number.isInteger(n) || n < 0) {
        throw new TypeError("Input must be an integer ≥ 0.");
    }
    if (n === 0 || n === 1) return false;

    if (primeSet.has(n)) return true;

    if (n % 2 === 0) return n === 2;
    let d = 3;
    while (d * d <= n) {
        if (n % d === 0) return false;
        d += 2;
    }
    return true;
}
