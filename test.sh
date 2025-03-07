#!/bin/bash

# Check if Node.js is installed
if ! command -v node &> /dev/null
then
    echo "Node.js is not installed! Installing..."
    sudo apt update
    sudo apt install -y nodejs npm
fi

echo "Running the tests..."

# Run tests with ES module support
node --input-type=module <<EOF
'use strict'
import { isPrime, getPrimes, iterPrimes } from './primes.mjs';
import { performance } from 'perf_hooks'; // Import for measuring execution time

function assertEqual(actual, expected, testName) {
    if (actual !== expected) {
        console.error(\`❌ \${testName} - FAIL (Expected: \${expected}, Received: \${actual})\`);
        process.exit(1);
    } else {
        console.log(\`✅ \${testName} - OK\`);
    }
}

function assertArrayEqual(actual, expected, testName) {
    if (actual.length !== expected.length) {
        console.error(\`❌ \${testName} - FAIL (Different lengths: Expected \${expected.length}, Received: \${actual.length})\`);
        console.error(\`Expected: \${expected.join(", ")}\`);
        console.error(\`Received: \${actual.join(", ")}\`);
        process.exit(1);
    }

    for (let i = 0; i < expected.length; i++) {
        if (actual[i] !== expected[i]) {
            console.error(\`❌ \${testName} - FAIL (Mismatch at index \${i})\`);
            console.error(\`Expected: \${expected.join(", ")}\`);
            console.error(\`Received: \${actual.join(", ")}\`);
            process.exit(1);
        }
    }

    console.log(\`✅ \${testName} - OK\`);
}

function measureExecutionTime(fn, args) {
    const start = performance.now();
    const result = fn(...args);
    const end = performance.now();
    return { result, time: end - start };
}

(async function() {
    console.log("🔹 Testing isPrime()...");
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
    console.log("🔹 Testing caching in isPrime()...");
    const firstExecution = measureExecutionTime(await isPrime, [1009]);
    console.log(\`⏳ First execution time: \${firstExecution.time.toFixed(3)}ms\`);

    const cachedExecution = measureExecutionTime(await isPrime, [1009]);
    console.log(\`⚡ Cached execution time: \${cachedExecution.time.toFixed(3)}ms\`);

    if (cachedExecution.time < firstExecution.time) {
        console.log(\`✅ Caching works! First: \${firstExecution.time.toFixed(3)}ms → Cached: \${cachedExecution.time.toFixed(3)}ms\`);
    } else {
        console.error(\`❌ Caching failed! Cached execution was slower or equal (\${cachedExecution.time.toFixed(3)}ms)\`);
    }

    // More tests
    assertEqual(await isPrime(1009), true, "isPrime(1009) should be true");
    assertEqual(await isPrime(104729), true, "isPrime(104729) should be true");

    console.log("🔹 Testing getPrimes()...");
    assertArrayEqual(await getPrimes(10), [2, 3, 5, 7], "getPrimes(10) should return [2, 3, 5, 7]");
    assertArrayEqual(await getPrimes(20), [2, 3, 5, 7, 11, 13, 17, 19], "getPrimes(20) should return correct primes");
    assertArrayEqual(await getPrimes(30), [2, 3, 5, 7, 11, 13, 17, 19, 23, 29], "getPrimes(30) should return correct primes");
    assertEqual((await getPrimes(50)).length, 15, "getPrimes(50) should return 15 primes");
    assertEqual((await getPrimes(100)).length, 25, "getPrimes(100) should return 25 primes");

    // Caching Test for getPrimes
    console.log("🔹 Testing caching in getPrimes(6000000)...");
    const firstExecutionPrimes = measureExecutionTime(await getPrimes, [6000000]);
    console.log(\`⏳ First execution time: \${firstExecutionPrimes.time.toFixed(3)}ms\`);

    const cachedExecutionPrimes = measureExecutionTime(await getPrimes, [6000000]);
    console.log(\`⚡ Cached execution time: \${cachedExecutionPrimes.time.toFixed(3)}ms\`);

    if (cachedExecutionPrimes.time < firstExecutionPrimes.time) {
        console.log(\`✅ Caching works! First: \${firstExecutionPrimes.time.toFixed(3)}ms → Cached: \${cachedExecutionPrimes.time.toFixed(3)}ms\`);
    } else {
        console.error(\`❌ Caching failed! Cached execution was slower or equal (\${cachedExecutionPrimes.time.toFixed(3)}ms)\`);
    }

    console.log("🔹 Testing iterPrimes()...");
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

    console.log("🔹 Testing error handling...");
    try {
        await isPrime(-1);
        console.error("❌ isPrime(-1) did not throw an error!");
        process.exit(1);
    } catch (e) {
        console.log("✅ isPrime(-1) correctly threw an error");
    }

    try {
        await isPrime(3.3);
        console.error("❌ isPrime(3.3) did not throw an error!");
        process.exit(1);
    } catch (e) {
        console.log("✅ isPrime(3.3) correctly threw an error");
    }

    try {
        await getPrimes(-10);
        console.error("❌ getPrimes(-10) did not throw an error!");
        process.exit(1);
    } catch (e) {
        console.log("✅ getPrimes(-10) correctly threw an error");
    }

    try {
        await isPrime("hello");
        console.error("❌ isPrime('hello') did not throw an error!");
        process.exit(1);
    } catch (e) {
        console.log("✅ isPrime('hello') correctly threw an error");
    }

    console.log("🎉 All tests passed!");
})();
EOF
