#!/bin/bash

# Configuración inicial (misma que antes)
echo "Step 1: Creating initial powersoftau file..."
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v

echo "Step 2: Making first contribution..."
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v

echo "Step 3: Preparing phase 2..."
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v

echo "Step 4: Setting up Groth16..."
snarkjs groth16 setup ../circuito.r1cs pot12_final.ptau circuito_0000.zkey

echo "Step 5: Making second contribution..."
snarkjs zkey contribute circuito_0000.zkey circuito_0001.zkey --name="Second contribution" -v

echo "Step 6: Exporting verification key..."
snarkjs zkey export verificationkey circuito_0001.zkey verification_key.json

# --- Nuevo: Procesamiento de múltiples inputs ---
INPUT_FILES=("../input1.json" "../input2.json")  # Ajusta las rutas

for INPUT_FILE in "${INPUT_FILES[@]}"; do
    # Extrae el nombre base sin extensión (ej: "input1" de "input1.json")
    BASE_NAME=$(basename "$INPUT_FILE" .json)
    
    echo "Processing $INPUT_FILE..."
    
    # Generar witness y prueba
    node ../circuito_js/generate_witness.js ../circuito_js/circuito.wasm "$INPUT_FILE" ../witness.wtns
    snarkjs groth16 prove circuito_0001.zkey ../witness.wtns "../proof_${BASE_NAME}.json" "../public_${BASE_NAME}.json"

    # Verificar
    snarkjs groth16 verify verification_key.json "../public_${BASE_NAME}.json" "../proof_${BASE_NAME}.json"
done

echo "All proofs completed!"