import React, { useState, useRef, useEffect } from 'react';
import { Video } from '../types/Video';
import VideoPlayer from '../components/videoPlayer';
import VideoDetail from '../components/videoDetail';
import VideoInteraction from '../components/videoInteraction';
import Header from '../components/header';
const mockVideos: Video[] = [
  {
    id: '1',
    username: '@codeMaster',
    description: 'Check out this awesome React tutorial! #coding #webdev',
    music: '♪ Original Sound - CodeMaster',
    likes: 1500,
    comments: 234,
    videoUrl: 'https://assets.mixkit.co/videos/3428/3428-720.mp4',
    userAvatar: 'https://picsum.photos/50/50',
  },
  {
    id: '2',
    username: '@webDev',
    description: 'Building amazing UIs with React and Tailwind 🚀 #webdev #ui',
    music: '♪ Coding Beats - WebDev',
    likes: 2300,
    comments: 456,
    videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4',
    userAvatar: 'https://picsum.photos/50/50',
  },
  {
    id: '3',
    username: '@techGuru',
    description: 'Learn TypeScript in 60 seconds! 💻 #typescript #programming',
    music: '♪ Tech Vibes - TechGuru',
    likes: 3400,
    comments: 567,
    videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-waves-in-the-water-1164-large.mp4',
    userAvatar: 'https://picsum.photos/50/50',
  },
];

const Videos: React.FC = () => {
  const [currentVideoIndex, setCurrentVideoIndex] = useState(0);
  const observerRef = useRef<IntersectionObserver | null>(null);

  useEffect(() => {
    observerRef.current = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            const index = Number(entry.target.getAttribute('data-index'));
            setCurrentVideoIndex(index);
          }
        });
      },
      {
        threshold: 0.6,
      }
    );

    return () => {
      if (observerRef.current) {
        observerRef.current.disconnect();
      }
    };
  }, []);

  useEffect(() => {
    const videos = document.querySelectorAll('.video-container');
    videos.forEach((video) => {
      if (observerRef.current) {
        observerRef.current.observe(video);
      }
    });
  }, []);

  return (
    <div className="h-screen w-full bg-[#0D0B1F] bg-gradient-to-b from-[#0D0B1F] via-[#171538] to-[#0D0B1F] overflow-hidden">
        <Header />
        <div className="snap-y snap-mandatory h-full overflow-y-scroll">
            {mockVideos.map((video, index) => (
            <div 
                key={video.id}
                className="video-container snap-start h-screen w-3/4 relative"
                data-index={index}
            >
                <VideoPlayer 
                video={video}
                isActive={currentVideoIndex === index}
                />
                <VideoDetail video={video}/>
                <VideoInteraction video={video} />
            </div>
            ))}
        </div>
    </div>
  );
};

export default Videos;
