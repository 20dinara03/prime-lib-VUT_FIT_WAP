# Primes.js - A JavaScript Library for Prime Numbers

## Project Overview

The goal of this project is to understand and apply JavaScript programming constructs, specifically generators and asynchronous programming. This library, `primes.mjs`, provides basic operations for working with prime numbers (assuming the data type `Number`).

## Features

The library exports the following functions:

- **`isPrime(number): Promise<boolean>`**  
  An asynchronous function that takes a number as input and returns a boolean value indicating whether the number is prime (`true`) or not (`false`).

- **`getPrimes(threshold): Promise<number[]>`**  
  An asynchronous function that returns an array of all prime numbers smaller than the given `threshold`.

- **`iterPrimes(): Generator<number>`**  
  A generator that iterates over prime numbers sequentially.

It is up to you to choose appropriate algorithms for prime number verification and generation. It is recommended to research and use well-known algorithms rather than inventing your own.  
Besides the predefined API, you are free to implement the library in your own way, but ensure that the library caches previously computed prime numbers until the program terminates.

## Installation

To use this library, you need **Node.js** installed on your system.

1. Clone this repository:
```sh
   git clone https://github.com/yourusername/primes-js.git
   cd primes-js
```
2. Import the library in your JavaScript code:
```js
import { isPrime, getPrimes, iterPrimes } from './primes.mjs';
```
## Usage
1. Check if a Number is Prime
```js
import { isPrime } from './primes.mjs';
(async () => {
    console.log(await isPrime(7));  // true
    console.log(await isPrime(10)); // false
})();
```
2. Get All Primes Below a Threshold
```js
import { getPrimes } from './primes.mjs';

(async () => {
    console.log(await getPrimes(10)); // [2, 3, 5, 7]
})();
```
3. Iterate Over Prime Numbers
```js
import { iterPrimes } from './primes.mjs';

const generator = iterPrimes();
console.log(generator.next().value); // 2
console.log(generator.next().value); // 3
console.log(generator.next().value); // 5
```
## Testing
1. The project includes a test script test.sh. Run the tests using:

```sh
sh test.sh
```
2. If additional dependencies are required for testing, install them using:

```sh
sh test.sh install
```
## Documentation
The project is documented using JSDoc. To generate documentation, run:

```sh
sh doc.sh
```
This script will extract comments from the code and create documentation.


Made with ❤️ by Dinara Garipova