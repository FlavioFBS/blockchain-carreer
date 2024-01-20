import React, { useEffect, useState } from 'react';
import Web3 from 'web3';
import Swal from 'sweetalert2';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Container from 'react-bootstrap/Container';
import Button from 'react-bootstrap/Button';
import smart_contract from '../abis/Loteria.json';
import logo from '../logo.png';

import Navigation from './Navbar';
import MyCarousel from './Carousel';


const Tokens = () => {
  const BUYING = 1;
  const [state, setState] = useState({
    account: '0x0',
    loading: true
  })
  const [contract, setContract] = useState({})
  const [errorMessage, setErrorMessage] = useState('');
  const [loading, setLoading] = useState(false);
  const [tokensForOperation, setTokensForOperation] = useState(0);

  const componentDidMount = async () => {
    // 1. Carga de Web3
    await loadWeb3()
    // 2. Carga de datos de la Blockchain
    await loadBlockchainData()
  }

  useEffect(() => {
    componentDidMount()
  }, [])

  // 1. Carga de Web3
  const loadWeb3 = async () => {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum)
      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
      console.log('Accounts: ', accounts)
    }
    else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider)
    }
    else {
      window.alert('¡Deberías considerar usar Metamask!')
    }
  }

  // 2. Carga de datos de la Blockchain
  const loadBlockchainData = async () => {
    const web3 = window.web3
    const accounts = await web3.eth.getAccounts()
    setState({ ...state, account: accounts[0] })
    // Ganache -> 5777, Rinkeby -> 4, BSC -> 97
    const networkId = await web3.eth.net.getId()
    console.log('networkid:', networkId)
    const networkData = smart_contract.networks[networkId]
    console.log('NetworkData:', networkData)

    if (networkData) {
      const abi = smart_contract.abi
      console.log('abi', abi)
      const address = networkData.address
      console.log('address:', address)
      const contract = new web3.eth.Contract(abi, address)
      setContract(contract)
    } else {
      window.alert('¡El Smart Contract no se ha desplegado en la red!')
    }
  }

  const balancetokens = async () => {
    try {
      console.log('balance de tokens ...');
      const balance = await contract.methods.balanceTokensERC20(state.account).call()
      console.log({ state, balanceERC20: balance });

      Swal.fire({
        icon: 'info',
        title: 'Balance tokens de usuario',
        width: 800,
        padding: '3em',
        text: `${balance} CHT`,
        backdrop: `
          rgba(15, 238, 168, 0.2)
          left top
          no-repeat
        `,
      })

    } catch (error) {
      setErrorMessage(error)
    } finally {
      setLoading(false);
    }
  }

  const balancetokensSC = async () => {
    try {
      console.log('balance de tokens SC...');
      const balanceSC = await contract.methods.balanceTokensSC().call()
      console.log({ state, balanceERC20: balanceSC });

      Swal.fire({
        icon: 'info',
        title: 'Balance tokens SC',
        width: 800,
        padding: '3em',
        text: `${balanceSC} CHT`,
        backdrop: `
          rgba(15, 238, 168, 0.2)
          left top
          no-repeat
        `,
      })

    } catch (error) {
      setErrorMessage(error)
    } finally {
      setLoading(false);
    }
  }

  const balanceEthersSC = async () => {
    try {
      console.log('balance de Ethers SC...');
      const balanceEthersSC = await contract.methods.balanceEthersSC().call()
      console.log({ state, balanceEthersSC });

      Swal.fire({
        icon: 'info',
        title: 'Balance Ethers SC',
        width: 800,
        padding: '3em',
        text: `${balanceEthersSC} ethers`,
        backdrop: `
          rgba(15, 238, 168, 0.2)
          left top
          no-repeat
        `,
      })

    } catch (error) {
      setErrorMessage(error)
    } finally {
      setLoading(false);
    }
  }

  const operationTokens = async (operationType) => {
    try {
      console.log('Ejecuntando compra de tokens', { tokensToBuy: tokensForOperation });
      // const ethers = web3.utils.toWei(numTokens, 'ether');
      const ethers = window.web3.utils.toWei(tokensForOperation, 'Ether');
      console.log({ ethers })
      if (operationType === BUYING) {
        await contract.methods.compraTokens(tokensForOperation).send({
          from: state.account,
          value: ethers
        })
      } else {
        await contract.methods.devolverTokens(tokensForOperation).send({
          from: state.account,
        })
      }

      Swal.fire({
        icon: operationType === BUYING ? 'success' : 'warning',
        title: `¡${operationType === BUYING ? 'Compra' : 'Devolución' } de tokens realizada!`,
        width: 800,
        padding: '3em',
        text: `${operationType === BUYING ? 'Compraste' : 'Devolviste' } ${tokensForOperation} token(s) por un valor de ${ethers / 10 ** 18} ethers`,
        backdrop: `
          rgba(15, 238, 168, 0.2)
          left top
          no-repeat
        `,
      })
    } catch (error) {
      console.log({ error })
      Swal.fire({
        icon: 'error',
        title: 'Hubo un problema',
        width: 800,
        padding: '3em',
        text: `No se pudo concretar la ${operationType === BUYING ? 'compra' : 'devolución' } de tokens`,
        backdrop: `
          rgba(15, 238, 168, 0.2)
          left top
          no-repeat
        `,
      })
    }
  }

  return (
    <div>
      <Navigation account={state.account} />
      <MyCarousel />
      <div className="container-fluid mt-5">
        <div className="row">
          <main role="main" className="col-lg-12 d-flex text-center">
            <div className="content mr-auto ml-auto" style={{width: '80%'}}>
              <h1>Tokens Management</h1>
              &nbsp;
              <Container>
                <Row>
                  <Col>
                    <h3>Users tokens</h3>
                    <Button onClick={async () => await balancetokens()}>Check balance</Button>
                  </Col>
                  <Col>
                    <h3>Tokens SC</h3>
                    <Button onClick={async () => await balancetokensSC()}>Check balance</Button>
                  </Col>
                  <Col>
                    <h3>Ethers SC</h3>
                    <Button onClick={async () => await balanceEthersSC()}>Check balance</Button>
                  </Col>

                </Row>
              </Container>
              &nbsp;
              -.-
              {state.account}
              &nbsp;
              <h3>Compra de Tokens ERC-20</h3>

              <input type="number"
                className="form-control mb-1"
                placeholder="Cantidad de tokens a comprar"
                onChange={(e) => setTokensForOperation(e.target.value)}
              />
              <Button onClick={async () => await operationTokens(BUYING)}>Comprar</Button>

              <h3>Devolución de Tokens ERC-20</h3>

              <input type="number"
                className="form-control mb-1"
                placeholder="Cantidad de tokens a devolver"
                onChange={(e) => setTokensForOperation(e.target.value)}
              />
              <Button onClick={async () => await operationTokens(0)}>Devolver</Button>


            </div>
          </main>
        </div>
      </div>
    </div>
  );
}

export default Tokens;
