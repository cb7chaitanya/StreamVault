import { atom } from 'recoil';
import { ethers } from 'ethers';
import { recoilPersist } from "recoil-persist";

const { persistAtom } = recoilPersist()

export const accountAtom = atom<string | null>({
    key: 'accountAtom',
    default: null,
    effects_UNSTABLE: [persistAtom],
});

export const signerAtom = atom<ethers.Signer | null>({
    key: 'signerAtom',
    default: null
});

export const providerAtom = atom<ethers.BrowserProvider | null>({
    key: 'providerAtom',
    default: null,
    effects_UNSTABLE: [persistAtom]
});

export const isConnectedAtom = atom<Boolean>({
    key: 'isConnectedAtom',
    default: false,
    effects_UNSTABLE: [persistAtom]
})