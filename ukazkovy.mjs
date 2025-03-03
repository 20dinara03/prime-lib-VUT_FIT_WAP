'use strict'
/**
 * \brief Ukázkový skript pro první projekt předmětu WAP
 */

/// Využijeme knihovnu, která je předmětem zadání projektu
import { isPrime, getPrimes, iterPrimes} from "./primes.mjs";
//, getPrimes, iterPrimes 

/// IIFE, které obsahuje testovací volání
(async function()
{
	/// 1: isPrime vrací Promise
	isPrime(2).then(result => console.log("2: ", result));
	isPrime(3).then(result => console.log("3: ", result));
	isPrime(4).then(result => console.log("4: ", result));
	isPrime(5).then(result => console.log("5: ", result));
	isPrime(6).then(result => console.log("6: ", result));
	isPrime(7).then(result => console.log("7: ", result));
	isPrime(2).then(result => console.log("2: ", result));
	// 2: getPrimes vrací prvočísla V Promise
	getPrimes(1000).then(primes => console.log(primes.join(", ")));
	// /// 3: generátor iterPrimes
	for (let prime of iterPrimes()) {
		if (prime > 1000) {
			console.log("1009:", prime === 1009);
			break;
		}
	}
})();
