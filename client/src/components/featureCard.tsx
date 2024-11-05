const FeatureCard = ({ icon, title, description }: { icon: string; title: string; description: string }) => (
    <div className="p-8 rounded-2xl bg-white/[0.02] backdrop-blur-lg border border-white/5 hover:border-purple-500/50 transition-all duration-300 hover:shadow-xl hover:shadow-purple-500/10 group">
      <div className="text-5xl mb-6 group-hover:scale-110 transition-transform duration-300">{icon}</div>
      <h4 className="text-2xl font-semibold mb-4 bg-gradient-to-r from-cyan-400 to-purple-400 bg-clip-text text-transparent">{title}</h4>
      <p className="text-gray-400/90 leading-relaxed">{description}</p>
    </div>
)

export default FeatureCard