import { FaComment, FaHeart, FaShare } from "react-icons/fa";
import { Video } from "../types/Video";

const VideoInteraction = ({ video }: { video: Video }) => {
  return (
    <div className="absolute right-4 bottom-20 flex flex-col items-center space-y-6">
      <button className="flex flex-col items-center group">
        <div className="w-10 h-10 bg-[#1F1F1F] group-hover:bg-purple-500 transition-colors rounded-full flex items-center justify-center mb-1">
          <FaHeart className="text-white text-xl" />
        </div>
        <span className="text-white text-sm">{video.likes}</span>
      </button>

      <button className="flex flex-col items-center group">
        <div className="w-10 h-10 bg-[#1F1F1F] group-hover:bg-purple-500 transition-colors rounded-full flex items-center justify-center mb-1">
          <FaComment className="text-white text-xl" />
        </div>
        <span className="text-white text-sm">{video.comments}</span>
      </button>

      <button className="flex flex-col items-center group">
        <div className="w-10 h-10 bg-[#1F1F1F] group-hover:bg-purple-500 transition-colors rounded-full flex items-center justify-center mb-1">
          <FaShare className="text-white text-xl" />
        </div>
        <span className="text-white text-sm">Share</span>
      </button>
    </div>
  );
};

export default VideoInteraction;
