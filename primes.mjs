let cachedPrimes = [2];
let primeSet = new Set(cachedPrimes); 

export async function isPrime(n) {
    if (n < 2) return false;
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

export async function getPrimes(n) {
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

export function* iterPrimes() {
    let index = 0;
    let current = cachedPrimes[cachedPrimes.length - 1];

    while (index < cachedPrimes.length)
        yield cachedPrimes[index++];
    
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

function isPrimeSync(n) {
    if (n < 2) return false;
    if (primeSet.has(n)) return true; 

    if (n % 2 === 0) return n === 2;
    let d = 3;
    while (d * d <= n) {
        if (n % d === 0) return false;
        d += 2;
    }
    return true;
}
