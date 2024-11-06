import { useNavigate } from "react-router-dom"

const Hero = () => {
  const navigate = useNavigate()
  return (
    <section className="container mx-auto pt-32 pb-20 relative">
          <div className="text-center max-w-3xl mx-auto px-4">
            <h2 className="text-6xl font-bold mb-6 bg-gradient-to-r from-cyan-400 via-purple-500 to-fuchsia-500 bg-clip-text text-transparent animate-gradient bg-[length:200%_auto]">
              Decentralized Short-Form Videos
            </h2>
            <p className="text-xl text-gray-300/90 mb-10 leading-relaxed">
              Create, share, and own your content on the blockchain. The future of social media is here.
            </p>
            <button 
                className="px-8 py-4 bg-gradient-to-r from-cyan-500 to-purple-600 rounded-full hover:scale-105 transition-all duration-300 text-lg font-semibold shadow-lg shadow-purple-500/25 hover:shadow-purple-500/40" 
                onClick={() => navigate('/videos')}
            >
                Start Streaming
            </button>
          </div>
    </section>

  )
}

export default Hero