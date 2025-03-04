let cachedPrimes = [2];

export async function isPrime(n) {
    if (n < 2) return false;
    if (cachedPrimes.includes(n)) return true; 

    if (n % 2 == 0){
        return (n == 2);
    }
    var d = 3;
    while (d * d <= n && n % d != 0){
        d+=2;
    }
    if (d * d > n){cachedPrimes.push(n);}
    return (d * d > n);
}

export async function getPrimes(n) {
    let lastCachedPrime = cachedPrimes.length > 0 ? cachedPrimes[cachedPrimes.length - 1] : 1;

    for (let i = lastCachedPrime + 1; i <= n; i++) {
        if (await isPrime(i) && !cachedPrimes.includes(i)) {
            cachedPrimes.push(i);
        }
    }
    return cachedPrimes.filter(prime => prime <= n);
}

export function* iterPrimes() {
    let index = 0;
    let current = cachedPrimes.length > 0 ? cachedPrimes[cachedPrimes.length - 1] : 2;

    while (index < cachedPrimes.length)
        yield cachedPrimes[index++];
    while (true) {
        while (!isPrimeSync(current)) { 
            current++;
        }
        if (!cachedPrimes.includes(current)) {
            cachedPrimes.push(current);
        }
        yield current; 
        current++; 
    }
}

function isPrimeSync(n) {
    if (n < 2) return false;
    if (cachedPrimes.includes(n)) return true;

    if (n % 2 === 0) return n === 2;
    let d = 3;
    while (d * d <= n) {
        if (n % d === 0) return false;
        d += 2;
    }
    return true;
}
