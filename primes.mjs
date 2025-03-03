let cachedPrimes = [];

export async function isPrime(n){
    if (n < 2) return false;
    if (cachedPrimes.includes(n)) return true;

    for (let prime of cachedPrimes) {
        if (prime * prime > n) break; 
        if (n % prime === 0) return false;
    }

    let d = cachedPrimes[cachedPrimes.length - 1] + 1;
    if (d % 2 === 0) d++; 

    while (d * d <= n) {
        if (n % d === 0) return false;
        d += 2;
    }

    cachedPrimes.push(n);
    return true;
}

export async function getPrimes(n){
    let lastCachedPrime = cachedPrimes[cachedPrimes.length - 1];
    if (n > lastCachedPrime) {
        for (let i = lastCachedPrime + 1; i <= n; i++) {
            if (await isPrime(i)) {
                cachedPrimes.push(i);
            }
        }
    }
    return cachedPrimes.filter(prime => prime <= n);
}