#!/bin/bash

# Check if Node.js is installed
if ! command -v node &> /dev/null
then
    echo "Node.js is not installed! Installing..."
    sudo apt update
    sudo apt install -y nodejs npm
fi

echo "Running the tests..."

# Check if the terminal supports colors
if [[ -t 1 ]] && [[ "$TERM" != "dumb" ]] && tput setaf 1 &>/dev/null; then
    RED="\u001b[31m"
    GREEN="\u001b[32m"
    YELLOW="\u001b[33m"
    BLUE="\u001b[34m"
    RESET="\u001b[0m"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    RESET=""
fi

# Run tests with ES module support
node --input-type=module <<EOF
'use strict'
import { isPrime, getPrimes, iterPrimes } from './primes.mjs';
import { performance } from 'perf_hooks'; // Import for measuring execution time

// Define color codes based on terminal support
const RED = "${RED}";
const GREEN = "${GREEN}";
const YELLOW = "${YELLOW}";
const BLUE = "${BLUE}";
const RESET = "${RESET}";

function assertEqual(actual, expected, testName) {
    if (actual !== expected) {
        console.error(\`\${RED}FAIL:\${RESET} \${testName} (Expected: \${expected}, Received: \${actual})\`);
        process.exit(1);
    } else {
        console.log(\`\${GREEN}PASS:\${RESET} \${testName}\`);
    }
}

function assertArrayEqual(actual, expected, testName) {
    if (actual.length !== expected.length) {
        console.error(\`\${RED}FAIL:\${RESET} \${testName} (Different lengths: Expected \${expected.length}, Received \${actual.length})\`);
        console.error(\`Expected: \${expected.join(", ")}\`);
        console.error(\`Received: \${actual.join(", ")}\`);
        process.exit(1);
    }

    for (let i = 0; i < expected.length; i++) {
        if (actual[i] !== expected[i]) {
            console.error(\`\${RED}FAIL:\${RESET} \${testName} (Mismatch at index \${i})\`);
            console.error(\`Expected: \${expected.join(", ")}\`);
            console.error(\`Received: \${actual.join(", ")}\`);
            process.exit(1);
        }
    }

    console.log(\`\${GREEN}PASS:\${RESET} \${testName}\`);
}

function measureExecutionTime(fn, args) {
    const start = performance.now();
    const result = fn(...args);
    const end = performance.now();
    return { result, time: end - start };
}

(async function() {
    console.log(\`\${BLUE}Testing isPrime()...\${RESET}\`);
   // Edge cases
    assertEqual(await isPrime(0), false, "isPrime(0) should be false");
    assertEqual(await isPrime(1), false, "isPrime(1) should be false");
    assertEqual(await isPrime(2), true, "isPrime(2) should be true");
    
    // Small prime and composite numbers
    assertEqual(await isPrime(3), true, "isPrime(3) should be true");
    assertEqual(await isPrime(4), false, "isPrime(4) should be false");
    assertEqual(await isPrime(5), true, "isPrime(5) should be true");
    assertEqual(await isPrime(9), false, "isPrime(9) should be false");
    assertEqual(await isPrime(15), false, "isPrime(15) should be false");
    assertEqual(await isPrime(29), true, "isPrime(29) should be true");

    // Even and odd numbers
    assertEqual(await isPrime(10), false, "isPrime(10) should be false");
    assertEqual(await isPrime(11), true, "isPrime(11) should be true");
    assertEqual(await isPrime(25), false, "isPrime(25) should be false");
    assertEqual(await isPrime(31), true, "isPrime(31) should be true");
    
    // Large prime and composite numbers
    assertEqual(await isPrime(1000), false, "isPrime(1000) should be false");
    assertEqual(await isPrime(1009), true, "isPrime(1009) should be true");
    assertEqual(await isPrime(1223), true, "isPrime(1223) should be true");
    assertEqual(await isPrime(2003), true, "isPrime(2003) should be true");
    assertEqual(await isPrime(2023), false, "isPrime(2023) should be false");
    assertEqual(await isPrime(7919), true, "isPrime(7919) should be true");

    // Very large prime and composite numbers
    assertEqual(await isPrime(104729), true, "isPrime(104729) should be true");
    assertEqual(await isPrime(1299709), true, "isPrime(1299709) should be true");
    assertEqual(await isPrime(5000000), false, "isPrime(5000000) should be false");

    // Caching Test
    console.log(\`\${BLUE}Testing caching in isPrime()...\${RESET}\`);
    const firstExecution = measureExecutionTime(await isPrime, [1009]);
    console.log(\`\${YELLOW}First execution time:\${RESET} \${firstExecution.time.toFixed(3)}ms\`);

    const cachedExecution = measureExecutionTime(await isPrime, [1009]);
    console.log(\`\${YELLOW}Cached execution time:\${RESET} \${cachedExecution.time.toFixed(3)}ms\`);

    if (cachedExecution.time < firstExecution.time) {
        console.log(\`\${GREEN}Caching works!\${RESET} First: \${firstExecution.time.toFixed(3)}ms → Cached: \${cachedExecution.time.toFixed(3)}ms\`);
    } else {
        console.error(\`\${RED}Caching failed!\${RESET} Cached execution was slower or equal (\${cachedExecution.time.toFixed(3)}ms)\`);
    }

    // More tests
    assertEqual(await isPrime(1009), true, "isPrime(1009) should be true");
    assertEqual(await isPrime(104729), true, "isPrime(104729) should be true");

    console.log(\`\${BLUE}Testing getPrimes()...\${RESET}\`);
    assertArrayEqual(await getPrimes(10), [2, 3, 5, 7], "getPrimes(10) should return [2, 3, 5, 7]");
    assertArrayEqual(await getPrimes(20), [2, 3, 5, 7, 11, 13, 17, 19], "getPrimes(20) should return correct primes");
    assertArrayEqual(await getPrimes(30), [2, 3, 5, 7, 11, 13, 17, 19, 23, 29], "getPrimes(30) should return correct primes");
    assertEqual((await getPrimes(50)).length, 15, "getPrimes(50) should return 15 primes");
    assertEqual((await getPrimes(100)).length, 25, "getPrimes(100) should return 25 primes");

    // Caching Test for getPrimes
    console.log(\`\${BLUE}Testing caching in getPrimes(6000000)...\${RESET}\`);
    const firstExecutionPrimes = measureExecutionTime(await getPrimes, [6000000]);
    console.log(\`\${YELLOW}First execution time:\${RESET} \${firstExecutionPrimes.time.toFixed(3)}ms\`);

    const cachedExecutionPrimes = measureExecutionTime(await getPrimes, [6000000]);
    console.log(\`\${YELLOW}Cached execution time:\${RESET} \${cachedExecutionPrimes.time.toFixed(3)}ms\`);

    if (cachedExecutionPrimes.time < firstExecutionPrimes.time) {
        console.log(\`\${GREEN}Caching works!\${RESET} First: \${firstExecutionPrimes.time.toFixed(3)}ms → Cached: \${cachedExecutionPrimes.time.toFixed(3)}ms\`);
    } else {
        console.error(\`\${RED}Caching failed!\${RESET} Cached execution was slower or equal (\${cachedExecutionPrimes.time.toFixed(3)}ms)\`);
    }

    console.log(\`\${BLUE}Testing iterPrimes()...\${RESET}\`);
    const generator = iterPrimes();
    assertEqual(generator.next().value, 2, "iterPrimes first prime should be 2");
    assertEqual(generator.next().value, 3, "iterPrimes second prime should be 3");
    assertEqual(generator.next().value, 5, "iterPrimes third prime should be 5");
    assertEqual(generator.next().value, 7, "iterPrimes fourth prime should be 7");

    // Checking large prime numbers
    let lastPrime;
    for (let i = 4; i < 200; i++) {
        lastPrime = generator.next().value;
    }
    assertEqual(lastPrime, 1223, "iterPrimes should generate the 200th prime 1223");

    console.log(\`\${BLUE}Testing error handling...\${RESET}\`);
    try {
        await isPrime(-1);
        console.error(\`\${RED}FAIL:\${RESET} isPrime(-1) did not throw an error!\`);
        process.exit(1);
    } catch (e) {
        console.log(\`\${GREEN}PASS:\${RESET} isPrime(-1) correctly threw an error\`);
    }

    try {
        await isPrime(3.3);
        console.error(\`\${RED}FAIL:\${RESET} isPrime(3.3) did not throw an error!\`);
        process.exit(1);
    } catch (e) {
        console.log(\`\${GREEN}PASS:\${RESET} isPrime(3.3) correctly threw an error\`);
    }

    try {
        await getPrimes(-10);
        console.error(\`\${RED}FAIL:\${RESET} getPrimes(-10) did not throw an error!\`);
        process.exit(1);
    } catch (e) {
        console.log(\`\${GREEN}PASS:\${RESET} getPrimes(-10) correctly threw an error\`);
    }

    try {
        await isPrime("hello");
        console.error(\`\${RED}FAIL:\${RESET} getPrimes("hello") did not throw an error!\`);
        process.exit(1);
    } catch (e) {
        console.log(\`\${GREEN}PASS:\${RESET} getPrimes("hello") correctly threw an error\`);
    }

    console.log(\`\${GREEN}All tests passed! \${RESET}\`);
})();
EOF
