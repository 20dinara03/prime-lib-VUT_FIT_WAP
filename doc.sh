#!/bin/bash

# Check if npx is installed
if ! command -v npx &> /dev/null
then
    echo "npx is not installed. Installing Node.js and JSDoc..."
    
    # Update package list
    sudo apt update

    # Install Node.js and npm (if not installed)
    sudo apt install -y nodejs npm

    # Install JSDoc locally
    npm install jsdoc

    # Verify installation
    if ! command -v npx &> /dev/null
    then
        echo "Installation failed. Please install Node.js and JSDoc manually."
        exit 1
    fi
    echo "Node.js and JSDoc installed successfully!"
fi

echo "Generating documentation for primes.mjs..."

# Create a temporary .js copy of the module
cp primes.mjs primes.js

# Run JSDoc to generate documentation
npx jsdoc primes.js -d docs --verbose

# Remove the temporary .js file after documentation is generated
rm primes.js

# Check if documentation was successfully created
if [ -d "docs" ]; then
    echo "Documentation successfully generated in the 'docs/' directory."
    echo "Open docs/index.html in a browser to view it."
else
    echo "Documentation generation failed. Please check for errors."
fi
