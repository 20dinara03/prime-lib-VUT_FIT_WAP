export async function isPrime(n){
    if (n % 2 == 0){
        return (n == 2);
    }
    var d = 3;
    while (d * d <= n && n % d != 0){
        d+=2;
    }
    return (d * d > n);
}

export async function getPrimes(n){
    let primes = [];
    for (var i = 2; i <= n; i++){
        if (await isPrime(i)){
            primes.push(i);
        }
    }
    return primes;
}