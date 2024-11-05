import { useWallet } from "../hooks/useWallet";
import { useRecoilValue } from "recoil";
import { accountAtom, isConnectedAtom } from "../store/atoms/wallet";

export const CreateWalletButton = () => {
    const { connectWallet } = useWallet()
    const isConnected = useRecoilValue(isConnectedAtom)
    const account = useRecoilValue(accountAtom)

    return (
        <div>
            {isConnected ? (
                <p>
                    Connected Account: {account}
                </p>
            ) : (
                <button onClick={connectWallet} className="px-6 py-2.5 bg-gradient-to-r from-cyan-500 to-purple-600 rounded-full hover:opacity-90 transition-all duration-300 shadow-lg shadow-purple-500/25 hover:shadow-purple-500/40">
                    Connect Wallet
                </button>
            )}
        </div>
    )   
}