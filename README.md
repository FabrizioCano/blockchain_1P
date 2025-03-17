## Instalar Circom
Ir al link (circom) [https://docs.circom.io/getting-started/installation/] y seguir los pasos de instalacion necesarios.
## Instalar snarkjs para generar y validad pruebas ZK
``npm install -g snarkjs`` 
## Compilar el circuito Circom a WebAssembly
- Ejecutar:
```circom circuito.circom --r1cs --wasm --sym``` y navegar al directorio creado ```cd circuito_js```

- Una vez en el directorio, ejecutar la siguiente linea para generar el testigo con los datos de entrada proveidos:


```node generate_witness.js circuito.wasm ../input.json ../witness.wtns```

- Luego ejecutar el script ``challenges.sh`` que contiene las configuraciones de la creacion de las pruebas y verificacion de las mismas.
- Opcional: si desea puede ejecutar el archivo map_public.js, de manera a colocar los labels de las variables a la salida o exposicion de los valores publicos y el resultado se generara en un archivo llamado ``public_with_names.json``.
```node map_public.js```
- Puede ejecutar el verificador en nodejs ``verify.js`` o en el navegador con el index.hml (puede exponerlo con la extension de live server de vscode).