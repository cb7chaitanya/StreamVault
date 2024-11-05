import FeatureCard from "./featureCard"

const FeatureSection = () => {
  return (
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
  )
}

export default FeatureSection