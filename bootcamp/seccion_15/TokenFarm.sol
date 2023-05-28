// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// contrato que gestiona todo el proyecto de defi
import "./JamToken.sol";
import "./chisiDefiToken.sol";

contract TokenFarm {
    string public name = "Chisi Token Farm";
    address public owner;

    // declarar contract importados
    JamToken public jamToken;
    ChisiDefiToken public chisiToken;

    // data structures
    address [] public stakers;
    // balance por persona, haciendo staking
    mapping (address => uint) stakingBalance;
    // para indicar si una persona ya hizo staking
    mapping (address => bool) public hasStaked;
    // para indicar si una persona está haciendo staking
    mapping (address => bool) public isStaking;

    constructor(ChisiDefiToken _chisiToken, JamToken _jamToken) {
        chisiToken = _chisiToken;
        jamToken = _jamToken;
        owner = msg.sender;
    }

    // cuando se haga staking, los tokens se enviarán a este contract
    function stakeTokens(uint _amount) public {
        // se requiere una cantidad superior a cero
        require(_amount > 0, "La cantidad debe ser mayor a cero");

        // transferir tokens JAM al smart contract principal
        jamToken.transferFrom(msg.sender, address(this), _amount);
        // actualizar saldo del staking
        stakingBalance[msg.sender] += _amount;
        // guardar el staker:
        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }
        // actualizar el estado del staking
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    // funcion para devolver los tokens (quitar staking de los tokens)
    function unstakeTokens() public {
        // verificar saldo de staker
        uint balance = stakingBalance[msg.sender];
        require(balance > 0, "El balance del staking debe ser mayor a cero");
        // transferir todo los tokens al usuario:
        jamToken.transfer(msg.sender, balance);
        // resetear balance de staking de usuario:
        stakingBalance[msg.sender] = 0;
        isStaking[msg.sender] = false;
    }

    // emitir tokens (recompensa):
    function issueTokens() public {
        require(msg.sender == owner,"No tienes permisos");
        // emitir tokens a todos los staker actuales (estén o no haciendo staking en el momento):
        // los tokens de recompensa son los chisiDefiToken
        for (uint i=0; i<stakers.length; i++) 
        {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if (balance > 0) {
                chisiToken.transfer(recipient, balance);
            }
        }
    }
}


/* Pasos para probar del proyecto Defi:
Desplegar en orden: JamToken, chisiDefiToken
Desplegar el TokenFarm, requiere los address de cada los contratos JamToken y chisiDefiToken

1 Verificar que el owner del proyecto tiene todo el balance de jamToken: JamToken.balanceOf(owner_address)

2. Owner enviará una cantidad de tokens a un usuario: JamToken.transfer(_to, _value);
    2.a Se verifica que el owner ahora tiene menos cantidad en el JamToken.balanceOf(owner_address);

3. Se verifica que el owner tiene todo el balance (de chisiTokens)

4. El tokenFarm debe tener una cantidad de tokens de chisiToken 
para poder hacer el entrega de recompensa por el staking al usuario que dejó su token,
por lo que desde el ChisiDefiToken se le aprueba que pueda operar con una cantidad: ChisiDefiToken.approve(_spender, _value);

5. Usando un usuario diferente al owner, hará staking: TokenFarm.stakeTokens(_amount);
    -precondición: como el usuario tiene tokens JamToken, desde el contract JamToken se tiene
    que aprovar una cantidad para que el contract TokenFarm pueda operarlos,
    se debe poner com spender al smart contract ChisiDefiToken

6. Usando el usuario own er, devolverá recompensas,
    en ChisiDefiToken, se verifica que su balance es menor por lo
    ocurrido en el punto 4.
    Se ejecuta la función TokenFarm.issueTokens(); y se emitirán recompensas a los stakers activos

7. Usando un usuario diferente al owner, y que sea staker activo,
    en su balance se verificará que a recibido la cantidad de tokens de tipo "ChisiDefiToken" según la programación del contrato: 

8. Con un usuario que hay recibido recompensa por staking,
    deja de ser staker activo (retirando sus fondos de ChisiDefiToken) usando TokenFarm.unstakeTokens()
    se verificará su saldo en el balance de JamToken, 

 */
