import { useEffect, useRef, useState } from "react";
import { Video } from "../types/Video";
import { FaPlay } from "react-icons/fa";

const VideoPlayer: React.FC<{
    video: Video;
    isActive: boolean;
  }> = ({ video, isActive }) => {
    const videoRef = useRef<HTMLVideoElement>(null);
    const [isPlaying, setIsPlaying] = useState(false);
    const [progress, setProgress] = useState(0);
  
    useEffect(() => {
      if (videoRef.current) {
        if (isActive) {
          videoRef.current.play();
          setIsPlaying(true);
        } else {
          videoRef.current.pause();
          setIsPlaying(false);
        }
      }
    }, [isActive]);
  
    const togglePlay = () => {
      if (videoRef.current) {
        if (isPlaying) {
          videoRef.current.pause();
          setIsPlaying(false);
        } else {
          videoRef.current.play();
          setIsPlaying(true);
        }
      }
    };
  
    const handleTimeUpdate = () => {
      if (videoRef.current) {
        const progress = (videoRef.current.currentTime / videoRef.current.duration) * 100;
        setProgress(progress);
      }
    };
  
    return (
      <div className="relative h-full w-full">
        <video
          ref={videoRef}
          className="h-full w-full object-cover"
          src={video.videoUrl}
          loop
          muted
          playsInline
          onTimeUpdate={handleTimeUpdate}
        />
        
        {/* Play/Pause Button Overlay */}
        <div 
          className="absolute inset-0 flex items-center justify-center cursor-pointer"
          onClick={togglePlay}
        >
          {!isPlaying && (
            <div className="bg-black bg-opacity-50 rounded-full p-4">
              <FaPlay className="text-white text-4xl" />
            </div>
          )}
        </div>
  
        {/* Progress Bar */}
        <div className="absolute bottom-0 left-0 w-full h-1 bg-gray-600">
          <div 
            className="h-full bg-white"
            style={{ width: `${progress}%` }}
          />
        </div>
      </div>
    );
};

export default VideoPlayer