import { useRecoilState } from "recoil";
import { ethers } from "ethers"
import { accountAtom, signerAtom, providerAtom, isConnectedAtom } from "../store/atoms/wallet";

declare global {
    interface Window {
        ethereum: any
    }
}

export function useWallet(){
    const [provider, setProvider] = useRecoilState(providerAtom)
    const [account, setAccount] = useRecoilState(accountAtom)
    const [signer, setSigner] = useRecoilState(signerAtom)
    const [isConnected, setIsConnected] = useRecoilState(isConnectedAtom)

    const connectWallet = async () => {
        if(typeof window.ethereum !== 'undefined'){
            const newProvider = new ethers.BrowserProvider(window.ethereum)
            setProvider(newProvider)

            await newProvider.send('eth_requestAccounts', [])
            const newSigner = await newProvider.getSigner()
            setSigner(newSigner)

            const accountAddress = await newSigner.getAddress()
            setAccount(accountAddress)
            setIsConnected(true)
        }
    }

    return { connectWallet, signer, account, provider, isConnected}
}