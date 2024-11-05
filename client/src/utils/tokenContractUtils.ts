import { ethers } from "ethers"

export async function requestFaucet(contract: ethers.Contract) {
    const tx = await contract.requestTokens()
    await tx.wait()
    console.log('Tokens recieved from faucet')
}