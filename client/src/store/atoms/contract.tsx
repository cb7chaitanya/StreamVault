import { ethers } from "ethers";
import { atom } from "recoil";

export const mockTokenContractAtom = atom<ethers.Contract | null>({
    key: 'mockTokenContractAtom',
    default: null
})

export const videoContractAtom = atom<ethers.Contract | null>({
    key: 'videoContractAtom',
    default: null
})