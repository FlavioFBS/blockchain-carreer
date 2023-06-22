// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


// contract MyToken is ERC20 {

//     constructor (uint256 _initialSupply) ERC20("Chisiripisiri", "CHP"){
//         _mint(msg.sender, _initialSupply);
//     }
// }

// Interfaz
interface MY_IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    // para transferencia de tokens
    function transfer(address to, uint256 amount) external returns (bool);

    // autorizar uso o gasto de tokens a otro usuario (spender)
    function allowance(address owner, address spender) external returns (uint256); 

    // establecer cantidad de tokens para prestar a otro usuario
    function approve(address spender, uint256 amount) external returns(bool);

    // transferencia de tokens con emisor
    function transferFrom(address from, address to, uint256 amount) external returns (bool);

    // evento
        // parametro indexado: se usa para filtrar
    event Transfer(address indexed from, address indexed to, uint256 value);

    // evento cuando se asigna un spender para un owner
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract my_ERC20 is MY_IERC20 {
    // estructuras de datos
    mapping (address => uint256) private _balances;
    // para los permisos que un owner le da a un spender
            // owner -----------spender -- amount que el owner le deja que el spender pueda gastar
    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _nameToken;
    string private _symbolToken;

    constructor(string memory _name, string memory _symbol) {
        _nameToken = _name;
        _symbolToken = _symbol;
    }

    function name() public view virtual returns (string memory) {
        return _nameToken;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbolToken;
    }

    // retorna la cantidad de decimales para el token
    function decimals() public view virtual returns(uint8) {
        /* los tokens ERC-20 son divisibles,
            con esta funcion se indica que con una cantidad de
            505, se pasa a 505/(10**18)
        */
        return 18;
    }

    // override: se usa en la funcion que anula a la funcion base (de una herencia)
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public virtual override returns(bool) {
        address owner = msg.sender;
        // funcion interna
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns(bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, _allowances[owner][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = msg.sender;
        uint256 currentAllowance = _allowances[owner][spender];
        require(currentAllowance >= subtractedValue, "Actualmente tiene menos tokens de los que se le quiere quitar.");
        // funcion para ahorrarse gas
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }
        return true;
    }

    // funciones internas:
    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: tranfer from the zero address");
        require(to != address(0), "ERC20: tranfer to the zero address");

        _beforeTokenTransfer(from,to, amount);
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;

        emit  Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }

    // para crear tokens erc20 y asignar
    function _mint(address account, uint amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply += amount;
        _balances[account] += amount;

        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);
    }

    // para quemar tokens(destruir)
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
        _beforeTokenTransfer(account, address(0), amount);
        uint256 accountBalance = _balances[account];

        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
        _afterTokenTransfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    // es para habilitar cantidad de tokens que estén permitidos para operar(transferir)
    // por ejm un usuario si le quiere pasar a otro, primero se le debe asignar a sí mismo como spender
    // con la cantidad de tokens que operará
    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        // si la persona no tiene el máximo de allowane asignado
        if (currentAllowance != type(uint256).max){
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    // Hooks:
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}

}

