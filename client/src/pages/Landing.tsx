import Header from "../components/header"
import Hero from "../components/hero"
import FeatureSection from "../components/featureSection"
import StatSection from "../components/statSection"
import Footer from "../components/footer"

const Landing = () => {
  return (
    <div className="min-h-screen bg-[#0D0B1F] bg-gradient-to-b from-[#0D0B1F] via-[#171538] to-[#0D0B1F] text-white">
      <div className="fixed inset-0 -z-10">
        <div className="absolute top-0 -left-40 w-96 h-96 bg-cyan-500/20 rounded-full blur-[128px]" />
        <div className="absolute top-48 -right-40 w-96 h-96 bg-purple-500/20 rounded-full blur-[128px]" />
        <div className="absolute bottom-0 left-40 w-96 h-96 bg-fuchsia-500/20 rounded-full blur-[128px]" />
      </div>
      <Header />
      <main>
        <Hero />
        <FeatureSection />
        <StatSection />
      </main>

      <Footer />
    </div>
  )
}

export default Landing