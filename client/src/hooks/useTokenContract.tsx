import { useRecoilState, useRecoilValue } from "recoil";
import { mockTokenABI, mockTokenAddress } from "../build_info/MockToken";
import { useEffect } from "react";
import { signerAtom } from "../store/atoms/wallet";
import { ethers } from "ethers";
import { mockTokenContractAtom } from "../store/atoms/contract";

export const useTokenContract = async () => {
    const [mockTokenContract, setMockTokenContract] = useRecoilState(mockTokenContractAtom)
    const signer = useRecoilValue(signerAtom) 

    useEffect(() => {
        if(signer &&  !mockTokenContract){
            const contract = new ethers.Contract(mockTokenAddress, mockTokenABI.abi, signer)
            setMockTokenContract(contract)
        }
    }, [signerAtom, mockTokenContract])

    return mockTokenContract
}   