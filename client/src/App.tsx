import './App.css'

const App = () => {
  return (
    <div className="min-h-screen bg-[#0D0B1F] bg-gradient-to-b from-[#0D0B1F] via-[#171538] to-[#0D0B1F] text-white">
      {/* Ambient background gradients */}
      <div className="fixed inset-0 -z-10">
        <div className="absolute top-0 -left-40 w-96 h-96 bg-cyan-500/20 rounded-full blur-[128px]" />
        <div className="absolute top-48 -right-40 w-96 h-96 bg-purple-500/20 rounded-full blur-[128px]" />
        <div className="absolute bottom-0 left-40 w-96 h-96 bg-fuchsia-500/20 rounded-full blur-[128px]" />
      </div>

      <header className="fixed top-0 w-full border-b border-white/5 bg-[#0D0B1F]/70 backdrop-blur-xl p-4 z-50">
        <div className="container mx-auto flex justify-between items-center">
          <h1 className="text-xl font-bold bg-gradient-to-r from-cyan-400 via-purple-500 to-fuchsia-500 bg-clip-text text-transparent">
            OnChain Videos
          </h1>
          <button className="px-6 py-2.5 bg-gradient-to-r from-cyan-500 to-purple-600 rounded-full hover:opacity-90 transition-all duration-300 shadow-lg shadow-purple-500/25 hover:shadow-purple-500/40">
            Connect Wallet
          </button>
        </div>
      </header>

      <main>
        {/* Hero Section */}
        <section className="container mx-auto pt-32 pb-20 relative">
          <div className="text-center max-w-3xl mx-auto px-4">
            <h2 className="text-6xl font-bold mb-6 bg-gradient-to-r from-cyan-400 via-purple-500 to-fuchsia-500 bg-clip-text text-transparent animate-gradient bg-[length:200%_auto]">
              Decentralized Short-Form Videos
            </h2>
            <p className="text-xl text-gray-300/90 mb-10 leading-relaxed">
              Create, share, and own your content on the blockchain. The future of social media is here.
            </p>
            <button className="px-8 py-4 bg-gradient-to-r from-cyan-500 to-purple-600 rounded-full hover:scale-105 transition-all duration-300 text-lg font-semibold shadow-lg shadow-purple-500/25 hover:shadow-purple-500/40">
              Start Creating
            </button>
          </div>
        </section>

        {/* Features Section */}
        <section className="container mx-auto py-32">
          <h3 className="text-4xl font-bold text-center mb-16 bg-gradient-to-r from-white via-purple-100 to-white bg-clip-text text-transparent">
            Why Choose OnChain Videos?
          </h3>
          <div className="grid md:grid-cols-3 gap-8 px-4">
            <FeatureCard 
              icon="🔒"
              title="True Ownership"
              description="Your content lives on the blockchain. You truly own what you create."
            />
            <FeatureCard 
              icon="💰"
              title="Creator Economy"
              description="Earn tokens for popular content. Direct monetization without intermediaries."
            />
            <FeatureCard 
              icon="🌐"
              title="Censorship Resistant"
              description="No central authority can remove your content or account."
            />
          </div>
        </section>

        {/* Stats Section */}
        <section className="relative py-32 overflow-hidden">
          <div className="absolute inset-0" />
          <div className="container mx-auto relative">
            <div className="grid md:grid-cols-3 gap-12 text-center">
              <StatCard number="100K+" label="Active Users" />
              <StatCard number="1M+" label="Videos Created" />
              <StatCard number="500K" label="NFTs Minted" />
            </div>
          </div>
        </section>
      </main>

      <footer className="border-t border-white/5 py-12 mt-20 backdrop-blur-lg">
        <div className="container mx-auto text-center text-gray-400">
          <p>© 2024 OnChain Videos. All rights reserved.</p>
        </div>
      </footer>
    </div>
  )
}

const FeatureCard = ({ icon, title, description }: { icon: string; title: string; description: string }) => (
  <div className="p-8 rounded-2xl bg-white/[0.02] backdrop-blur-lg border border-white/5 hover:border-purple-500/50 transition-all duration-300 hover:shadow-xl hover:shadow-purple-500/10 group">
    <div className="text-5xl mb-6 group-hover:scale-110 transition-transform duration-300">{icon}</div>
    <h4 className="text-2xl font-semibold mb-4 bg-gradient-to-r from-cyan-400 to-purple-400 bg-clip-text text-transparent">{title}</h4>
    <p className="text-gray-400/90 leading-relaxed">{description}</p>
  </div>
)

const StatCard = ({ number, label }: { number: string; label: string }) => (
  <div className="p-8 rounded-2xl bg-white/[0.02] backdrop-blur-lg border border-white/5">
    <div className="text-5xl font-bold bg-gradient-to-r from-cyan-400 to-purple-400 bg-clip-text text-transparent mb-4">{number}</div>
    <div className="text-lg text-gray-300/90">{label}</div>
  </div>
)

export default App
