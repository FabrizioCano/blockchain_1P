#!/bin/bash

# 1. Iniciar una nueva ceremonia de powersoftau
echo "Step 1: Creating initial powersoftau file..."
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v

# 2. Realizar la primera contribución
echo "Step 2: Making first contribution..."
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v

# 3. Preparar la fase 2
echo "Step 3: Preparing phase 2..."
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v

# 4. Configurar el circuito Groth16
echo "Step 4: Setting up Groth16..."
snarkjs groth16 setup ../circuito.r1cs pot12_final.ptau circuito_0000.zkey

# 5. Realizar la segunda contribución
echo "Step 5: Making second contribution..."
snarkjs zkey contribute circuito_0000.zkey circuito_0001.zkey --name="Second contribution" -v

# 6. Exportar la clave de verificación
echo "Step 6: Exporting verification key..."
snarkjs zkey export verificationkey circuito_0001.zkey verification_key.json

# 7. Generar la prueba
echo "Step 7: Generating proof..."
snarkjs groth16 prove circuito_0001.zkey ../witness.wtns ../proof.json ../public.json

# 8. Verificar la prueba
echo "Step 8: Verifying proof..."
snarkjs groth16 verify verification_key.json ../public.json ../proof.json

echo "All steps completed!"