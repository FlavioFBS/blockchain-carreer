import React, { useState } from 'react';
import logoJam from '../logo.png';


const Main = (
  props
) => {

  const [inputStake, setInputStake] = useState(0)

  const unstake = (e) => {
    e.preventDefault();
    props.unstakeTokens();
  }

  console.log({
    props
  });
  return (
    <div id="content" className='mt-3'>
      <table className='table table-borderless text-muted text-center'>
        <thead>
          <tr>
            <th scope='col'>Balance de Staking</th>
            <th scope='col'>Balance de recompensas</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td> {window.web3.utils.fromWei(props.stakingBalance, 'Ether')} Jam</td>
            <td> {window.web3.utils.fromWei(props.chisiDefiTokenBalance, 'Ether')} ChisiDefi</td>
          </tr>
        </tbody>
      </table>

      <div className="card mb-4">
        <div className="card-body">
          <form className="mb-3" onSubmit={(event) => {
            event.preventDefault()
            // let amount = this.input.value.toString();
            let amount = window.web3.utils.toWei(inputStake, 'Ether');
            props.stakeTokens(amount);
          }}>
            <div className="">
              <label className="float-left">
                <b>Stake Tokens</b>
              </label>
              <span className="float-right text-muted">
                Balance: {window.web3.utils.fromWei(props.jamTokenBalance, 'Ether')}
              </span>
            </div>

            <div className="input-group mb-4">
              <input 
                className='form-control form-control-lg' 
                placeholder='0' 
                required
                type="text"
                onChange={(event) => setInputStake(event.target.value)}
              />
              <div className="input-group-append">
                <div className="input-group-text">
                  <img src={logoJam} height={32} alt="" />
                  &nbsp;&nbsp; JAM
                </div>
              </div>
            </div>

            <button type='submit' className="btn btn-primary btn-block btn-lg">Stake!</button>
          </form>

          <button 
            className="btn btn-warning"
            onClick={unstake}
          >Retirar Stake</button>
        </div>
      </div>

    </div>
  )
}

export default Main
