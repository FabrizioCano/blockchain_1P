# 1) Estructura del circuito

El circuito escrito en Circom tiene la siguiente estructura:\
a) Un template principal llamado ``Circuito()`` en donde se realizan las invocaciones a los demas templates involucrados en el circuito.\

- ``Suma()``: template que calcula la suma de dos numeros
- ``Potencia()``: template que calcula el cuadrado de un numero
- ``Modulo()``: template que calcula la operacion modulo entre dos numeros.

Se define la signal c y p como output publico mientras que a y b permanecen privados ya que son declaradas como inputs.



## 2) Proceso de generación de pruebas
```circom
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
```
- Primeramente se genera una ceremonica de Powers of Tau, que es un proceso de configuracion confiable necesaria para generar los parametros publicos del sistema zk-SNARK. EL archivo generado aqui contiene los parametros criptograficos necesarios para la configuracion confiable.
```circom
ssnarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
```

- Luego se realiza la primera contribucion a la ceremonia añadiendo aleatoriedad al proceso para garantizar la seguridad del sistema.
```circom
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
```
- Luego se prepara los parametros para la segunda fase de la ceremonia que es especifica para el circuito que se esta utilizando.
```circom
snarkjs groth16 setup ../circuito.r1cs pot12_final.ptau circuito_0000.zkey
```

- A continuacion se configura el circuito para el protocolo de pruebas zk-SNARK Groth16. Para generar las claves necesarias para crear y verificar pruebas.
```circom
snarkjs zkey contribute circuito_0000.zkey circuito_0001.zkey --name="Second contribution" -v
```
- Se realiza una segunda contribucion para generar mas aleatoriedad a las claves de prueba y verificacion.
```circom
snarkjs zkey export verificationkey circuito_0001.zkey verification_key.json
```
- Se exporta la clave de verificacion en fromato JSON para su uso posterior.
```circom
snarkjs groth16 prove circuito_0001.zkey ../witness.wtns ../proof.json ../public.json
```
- Por ultimo se genera la prueba para un conjunto de valores de entrada


## 3) Verificacion de pruebas
- Se procede a verificar que la prueba generada es valida y cumple con las restricciones definidas en el circuito.
```circom
snarkjs groth16 prove circuito_0001.zkey ../witness.wtns ../proof.json ../public.json
```
- Verificacion en nodejs:
```verify.js```:  en este archivo se utiliza la libreria snarkjs para manejar las operaciones de verificacion. Si la prueba es valida imprime ``Proof valid:True``
- Verificacion en un navegador:
``index.hmtl``: en este archivo se utiliza snarkjs para probar el verificador en un navegador

## 4) Ejemplos de uso
- Se define el archivo input.json y se provee los valores de a b y p para testear el circuito.
```circom
node generate_witness.js circuito.wasm ../input.json ../witness.wtns
```
input.json:
```json
{
    "a": 5,
    "b": 4,
    "p": 5
}
Resultado:
{
  "c": "1",
  "p": "5"
}
Donde c representa al resultado de la operacion modulo y p al numero primo utilizado para el calculo.
```