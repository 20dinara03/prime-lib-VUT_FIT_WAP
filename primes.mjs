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