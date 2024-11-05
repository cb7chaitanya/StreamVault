import { useRecoilState, useRecoilValue } from "recoil";
import { mockTokenABI, mockTokenAddress } from "../build_info/MockToken";
import { useEffect } from "react";
import { signerAtom } from "../store/atoms/wallet";
import { ethers } from "ethers";
import { videoContractAtom } from "../store/atoms/contract";

export const useVideoContract = async () => {
    const [videoContract, setVideoContract] = useRecoilState(videoContractAtom)
    const signer = useRecoilValue(signerAtom) 

    useEffect(() => {
        if(signer &&  !videoContract){
            const contract = new ethers.Contract(mockTokenAddress, mockTokenABI.abi, signer)
            setVideoContract(contract)
        }
    }, [signerAtom, videoContract])

    return videoContract
}   