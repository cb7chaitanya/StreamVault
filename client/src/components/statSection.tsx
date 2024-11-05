import StatCard from "./statCard"

const StatSection = () => {
  return (
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
  )
}

export default StatSection