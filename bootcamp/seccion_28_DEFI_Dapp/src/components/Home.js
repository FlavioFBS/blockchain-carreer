import React, { useEffect, useState } from 'react';
import Web3 from 'web3';
import JamToken from '../abis/JamToken.json';
import ChisiDefiToken from '../abis/ChisiDefiToken.json';
import TokenFarm from '../abis/TokenFarm.json';
import logoToken from '../logo.png';

import Navigation from './Navbar';
import MyCarousel from './Carousel';
import Main from './Main';

const App = () => {
  const [account, setAccount] = useState('0x0');
  const [loading, setLoading] = useState(true);
  const [jamToken, setJamToken] = useState({});
  const [jamTokenBalance, setJamTokenBalance] = useState('');
  const [chisiDefiToken, setChisiDefiToken] = useState({});
  const [chisiDefiTokenBalance, setChisiDefiTokenBalance] = useState('');
  const [tokenFarm, setTokenFarm] = useState({});
  const [stakingBalance, setStakingBalance] = useState('');

  useEffect(() => {
    // 1. Carga de Web3
    loadWeb3().then(() => {
      console.log('complete loadWeb3');
      // 2. Carga de datos de la Blockchain
      loadBlockchainData().then(() => {
        console.log('complete loadBlockchainData');
        setLoading(false);
      });
    })
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
    console.log('loading data from blockchain')
    const web3 = window.web3
    const accounts = await web3.eth.getAccounts()
    console.log({ accounts });
    setAccount(accounts[0])
    // Ganache -> 5777, Rinkeby -> 4, BSC -> 97
    const networkId = await web3.eth.net.getId()
    console.log('networkid:', networkId)
    console.log({ accounts_loading: accounts });

    const jamTokenData = JamToken.networks[networkId];
    if (jamTokenData) {
      console.log('get jamtoken');
      const jamtokenValue = new web3.eth.Contract(JamToken.abi, jamTokenData.address);
      console.log('check jamtoken balance: ', accounts[0]);
      let jamTokenBalance = await jamtokenValue.methods.balanceOf(accounts[0]).call();
      setJamTokenBalance(jamTokenBalance)
      setJamToken(jamtokenValue);
    } else {
      window.alert('No se a cargado el jamToken en la red');
    }

    const chisiDefiTokenData = ChisiDefiToken.networks[networkId];
    if (chisiDefiTokenData) {
      console.log('get chisidefitoken');

      const chisiDefiToken = new web3.eth.Contract(ChisiDefiToken.abi, chisiDefiTokenData.address);
      let chisiDefiTokenBalance = await chisiDefiToken.methods.balanceOf(accounts[0]).call();
      setChisiDefiToken(chisiDefiToken);
      setChisiDefiTokenBalance(chisiDefiTokenBalance);
    } else {
      window.alert('No se a cargado el chisiDefiToken en la red');
    }

    const tokenFarmData = TokenFarm.networks[networkId];
    if (tokenFarmData) {
      const tokenFarm = new web3.eth.Contract(TokenFarm.abi, tokenFarmData.address);
      let stakingBalance = await tokenFarm.methods.stakingBalance(accounts[0]).call();
      setStakingBalance(stakingBalance);
      setTokenFarm(tokenFarm);
    } else {
      window.alert('No se a cargado el tokenFarm en la red');
    }
    console.log('finish data from blockchain');
  }

  const stakeTokens = (amount) => {
    setLoading(true);

    jamToken.methods.approve(tokenFarm._address, amount)
      .send({ from: account })
      // esperar hasta que se genere la transaccion:
      .on('transactionHash', (hash) => {
        tokenFarm.methods.stakeTokens(amount).send({ from: account })
          .on('transactionHash', (hash) => {
            setLoading(false);
          })
      });
  }

  const unstakeTokens = (amount) => {
    setLoading(true);

    tokenFarm.methods.unstakeTokens().send({ from: account })
      .on('transacctionHash', (hash) => {
        setLoading(false);
      })
  };

  return (
    <div>
      <Navigation account={account} />
      <MyCarousel />
      <div className="container-fluid mt-5">
        <div className="row">
          <main role="main" className="col-lg-12 d-flex text-center">
            <div className="content mr-auto ml-auto">
              <img src={logoToken} className="App-logo" alt="" height="20%" />
              {loading && (
                <p id='loader' className='text-center'>Loading...</p>
              )}
              {!loading && (
                <>
                  <p>Balance JamToken: {window.web3.utils.fromWei(jamTokenBalance, 'Ether')}</p>
                  <Main
                    jamTokenBalance={jamTokenBalance}
                    chisiDefiTokenBalance={chisiDefiTokenBalance}
                    stakingBalance={stakingBalance}
                    stakeTokens={stakeTokens}
                    unstakeTokens={unstakeTokens}
                  />
                </>
              )}
            </div>
          </main>
        </div>
      </div>
    </div>
  );
}


export default App;
