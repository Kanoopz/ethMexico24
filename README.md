# ethMexico24
frutalWebHouseHackathon

//  DESCRIPCION  ///
"metAstarSavingsProtocol" es un protocolo que tiene cuatro principales objetivos:
- Añadir astarNetwork a la oferta de chains del servicio de liquidStaking de meta pool.

- Ofrecer yieldMaximization sobre el capital invertido aplicando hasta tres diferentes metorodos de yield: liquidStaking, flashloans y lending&borrowing fees.

- Expandir el feature de dAppStaking de astarEvmL1 a traves de liquidStaking a astarZkevmL2 donde aún no está disponible.

- Disponer de un protocolo defi de lending&borrowing que le de un caso de uso real a la liquidStablecoin que incentive su adopción.



//  YIELD_METHODS   ///
- liquidStaking: Al usar liquidStaking assets como colateral para mintear stablecoins, mpEth y NASTR siguen generando rendimientos, por lo que no importa si se usa la stablecoin o solo se holdea, producen un 4% y 20% anual respectivamente.

- flashloans: Los liquidStaking assets que sirven como colateral para mintear stablecoins, se quedan en una boveda dado que es lo que garantiza el valor de la paridad 1:1 con el dolar, debido a esto, ese capital está parado sin generar rendimientos. La única forma disponible de generar rendimientos es a traves de flashloans que se aseguran de que en la misma TX se devuelva el capital prestado, requiriendo un fee del 10% que se reparte entre los minters que bloquearon sus liquidStaking assets.

- lendingProtocol: Al bloquear liquidStablecoins como liquidez para el lendingProtocol, los usuarios que las aportaron ganan fees de la posiciones de prestamos que se realizan en el protocolo.



//  CONSIDERACIONES_TECNICAS   ///
- Se usa los precompiles de astarEvmL1 para interactuar con el runtime de la chain desde los smartContracts para acceder a la funcionalidad de dAppStaking y poder implementar liquidStaking.
- Se usa la tecnología de layerZero para hacer la migración crossChain de astarUsd y mpUsd hacia astarZkevmL2.
- Para acceder al precio de ether en ethereum se usa el priceFeed del oraculo de chainlink.
- Para acceder al precio de astar en astarEvmL2 se usa el priceFeed del oraculo de DIA.
- Para acceder al precio de wrappedBitcoin en astarZkevmL2 se usa el priceFeed del oraculo de API3.



//  ARQUITECTURA   ///



//  DEPLOYED_SMART_CONTRACTS   ///

//  ethereumSepolia //////////////////////////////////////////////////////
- mpEth:                            0xe50339fE67402Cd59c32656D679479801990579f
- mpVault:                          0x3051dEB4cA8413a87362DF7B6dd7d5C86559C720
- mpUsd:                            0x9D43AEcb177F0B0B0572764E5547478242145e74
- ethereumEndpoint:                 0xdA7B7e49C586244571491fd6924C4D9eC4f081a1


//  astarEvmShibuya //////////////////////////////////////////////////////
- NASTR:                            0xE19D20B8490c50993E40c53c6849d572357f3Ecb
- astarVault:                       0x56A19dD5032400E6c2A8eb60C818BA3faB34AdEb
- astarUsd:                         0x0aAcEEC390386E300080811dF0b713fC0Af3D843
- astarEvmEndpoint:                 0xE385E20709DD6bBEDF8c0572d61bFF60138A6368


//  astarZkevmL2 /////////////////////////////////////////////////////////
- astarZkL2EthereumEndpoint:        0x0542718f7215b442dE75A5aC5e25E3c9d8E1Bf36
- zkL2MpUsd:                        0x8c0a3f863Bef1F709FA3F7f42eD9Efd8FEF6D6fC

- astarZkL2AstarEvmEndpoint:        0x536422738b343750D9637268507647e627061a6d
- zkL2AstarUsd:                     0x8d1f6698C2dee8ADf1A53582D096AD7a7030afFa

- wrappedBitcoin:                   0x182426cdEAfe2E6877915D7A68165d313Ca93F87

- metastarSavingsLendingProtocol:   0xee4B3583c436D0262CB518884e60fFd088c84ec4