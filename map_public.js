const fs = require("fs");

// Load the public.json file
const publicValues = JSON.parse(fs.readFileSync("public.json", "utf8"));

// Define the variable names in the order they appear in the public.json file
const publicVariables = ["c", "p"];

// Map variable names to values
const publicWithNames = {}; 
publicVariables.forEach((name, index) => {
    publicWithNames[name] = publicValues[index];
});

// Save the result to a new file
fs.writeFileSync("public_with_names.json", JSON.stringify(publicWithNames, null, 2));

console.log("Mapped public variables with names:");
console.log(publicWithNames);