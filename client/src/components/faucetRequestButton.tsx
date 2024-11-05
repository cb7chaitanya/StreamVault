import { useTokenContract } from "../hooks/useTokenContract"
import { requestFaucet } from "../utils/tokenContractUtils"

const FaucetRequestButton = () => {
  
  const handleFaucetRequest = async() => {
    const mockTokenContract = await useTokenContract()
    if(mockTokenContract){
      await requestFaucet(mockTokenContract)
    } else {
      console.error('Contract not initialized!')
    }
  }
  return (
    <button onClick={handleFaucetRequest}>Request tokens from faucet</button>
  )
}

export default FaucetRequestButton