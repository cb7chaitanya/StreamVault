const StatCard = ({ number, label }: { number: string; label: string }) => (
    <div className="p-8 rounded-2xl bg-white/[0.02] backdrop-blur-lg border border-white/5">
      <div className="text-5xl font-bold bg-gradient-to-r from-cyan-400 to-purple-400 bg-clip-text text-transparent mb-4">{number}</div>
      <div className="text-lg text-gray-300/90">{label}</div>
    </div>
)
export default StatCard
  