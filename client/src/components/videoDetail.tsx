import { Video } from "../types/Video";
import { FaMusic } from "react-icons/fa";
const VideoDetail = ({video}: {video: Video}) => {
  return (
    <div className="absolute bottom-0 left-0 right-0 p-4 text-white bg-gradient-to-t from-[#0F0F0F]/90 to-transparent">
      {/* User Info and Description */}
      <div className="mb-4">
        <div className="flex items-center mb-2">
          <img
            src={video.userAvatar}
            alt={video.username}
            className="w-10 h-10 rounded-full mr-2 border-2 border-purple-500"
          />
          <span className="font-bold text-purple-400">{video.username}</span>
        </div>
        <p className="text-sm text-gray-200">{video.description}</p>
        <div className="flex items-center mt-2">
          <FaMusic className="mr-2 text-purple-400" />
          <span className="text-sm text-gray-300">{video.music}</span>
        </div>
      </div>
    </div>
  );
};

export default VideoDetail;
