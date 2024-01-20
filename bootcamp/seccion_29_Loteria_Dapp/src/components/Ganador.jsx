import React, { useEffect, useState } from 'react';
import Web3 from 'web3';
import Swal from 'sweetalert2';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Container from 'react-bootstrap/Container';
import Button from 'react-bootstrap/Button';
import smart_contract from '../abis/Loteria.json';
import Navigation from './Navbar';
import MyCarousel from './Carousel';

const Ganador = () => {

  const [state, setState] = useState({
    account: '0x0',
    loading: true
  })
  const [contract, setContract] = useState({})
  const [existWinner, setExistWinner] = useState(false);

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

  const generateWinner = async () => {
    try {
      await contract.methods.generarGanador().send({
        from: state.account
      })
      setExistWinner(true);
      Swal.fire({
        icon: 'success',
        title: '¡Ganador generado!',
        width: 800,
        padding: '3em',
        backdrop: `
          rgba(15, 238, 168, 0.2)
          left top
          no-repeat
        `,
      })
    } catch (error) {
      Swal.fire({
        icon: 'error',
        title: 'Hubo un problema',
        width: 800,
        padding: '3em',
        backdrop: `
          rgba(15, 238, 168, 0.2)
          left top
          no-repeat
        `,
      })
    }
  }

  const getWinner = async () => {
    try {
      const winner = await contract.methods.ganador().call()
      Swal.fire({
        icon: 'success',
        title: '¡El Ganador de la lotería es!',
        width: 800,
        text: `${winner}`,
        padding: '3em',
        backdrop: `
          rgba(15, 238, 168, 0.2)
          left top
          no-repeat
        `,
      })
    } catch(error) {
      Swal.fire({
        icon: 'error',
        title: 'Hubo un problema',
        width: 800,
        padding: '3em',
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
              <h2>Gestión de sorteo</h2>
              <Button onClick={async () => await generateWinner()}>Generar Ganador</Button>
              {existWinner && (
                <Button onClick={async () => await getWinner()}>Mostar ganador</Button>
              )}

            </div>
          </main>
        </div>
      </div>
    </div>
  )
}

export default Ganador