const snarkjs = require("snarkjs");
const { readFileSync } = require("fs");

async function verifyProof() {
    try {
        // 1. Cargar la clave de verificación, la prueba y las señales públicas
        const verificationKey = JSON.parse(readFileSync("./circuito_js/verification_key.json"));
        const proof = JSON.parse(readFileSync("./proof.json"));
        const publicSignals = JSON.parse(readFileSync("./public.json"));

        // 2. Verificar la prueba
        const isValid = await snarkjs.groth16.verify(verificationKey, publicSignals, proof);
        console.log("Proof is valid:", isValid);
    } catch (error) {
        console.error("Error during verification:", error);
    }
}

verifyProof();