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

const Loteria = () => {

  const [state, setState] = useState({
    account: '0x0',
    loading: true,
  })
  const [ticketValue, setTicketValue] = useState(0)
  const [contract, setContract] = useState({})
  const [errorMessage, setErrorMessage] = useState('');
  const [loading, setLoading] = useState(false);
  const [ticketsAmount, setTicketsAmount] = useState(0);


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
      const ticketValue = await contract.methods.precioBoleto().call()
      console.log({ ticketValue });
      setTicketValue(ticketValue)
    } else {
      window.alert('¡El Smart Contract no se ha desplegado en la red!')
    }
  }

  const compraBoletos = async (numBoletos) => {
    try {
      await contract.methods.compraBoleto(numBoletos).send({
        from: state.account
      })
      Swal.fire({
        icon: 'info',
        title: 'Boletos comprados exitosamente',
        width: 800,
        padding: '3em',
        text: `Compraste ${numBoletos} boletos`,
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
        text: `No se pudo comprar boletos`,
        backdrop: `
          rgba(15, 238, 168, 0.2)
          left top
          no-repeat
        `,
      })
    }
  }

  const getMytickets = async () => {
    try {
      console.log({ state });
      const boletos = await contract.methods.tusBoletos(state.account).call()
      console.log({ boletos })
      Swal.fire({
        icon: 'info',
        title: 'Tus boletos son',
        width: 800,
        padding: '3em',
        text: `${boletos}`,
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
        text: `No se pudo obtener tus boletos`,
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
            <div className="content mr-auto ml-auto" style={{ width: '80%' }}>
              <h1>Gestión de Lotería con ERC-20 y ERC-721</h1>
              <h3>Compra de boletos</h3>
              <p>Cada Boleto cuesta {ticketValue} CHT</p>
              <input type="number"
                className="form-control mb-1"
                placeholder="Cantidad de boletos"
                onChange={(e) => setTicketsAmount(e.target.value)}
              />
              <Button onClick={async () => await compraBoletos(ticketsAmount)}>Comprar</Button>

              <Container>
                <Row>
                  <Col>
                    {/* <h3>Tus Boletos</h3> */}
                    <Button onClick={async () => await getMytickets()}>Ver mis boletos</Button>

                  </Col>
                </Row>
              </Container>
            </div>
          </main>
        </div>
      </div>
    </div>
  )
}

export default Loteria