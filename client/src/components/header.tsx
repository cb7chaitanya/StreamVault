import { CreateWalletButton } from "./connectWalletButton"

const Header = () => {
  return (
    <header className="fixed top-0 w-full border-b border-white/5 bg-[#0D0B1F]/70 backdrop-blur-xl p-4 z-50">
        <div className="container mx-auto flex justify-between items-center">
          <h1 className="text-xl font-bold bg-gradient-to-r from-cyan-400 via-purple-500 to-fuchsia-500 bg-clip-text text-transparent">
            OnChain Videos
          </h1>
          <CreateWalletButton />
        </div>
    </header>
  )
}

export default Header