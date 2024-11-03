module.exports = {
  theme: {
    extend: {
      colors: {
        primary: '#8B5CF6', // Purple
        secondary: '#06B6D4', // Cyan
      },
      animation: {
        gradient: 'gradient 6s linear infinite',
      },
      keyframes: {
        gradient: {
          '0%, 100%': {
            'background-position': '0% 50%',
          },
          '50%': {
            'background-position': '100% 50%',
          },
        },
      },
    },
  },
} 