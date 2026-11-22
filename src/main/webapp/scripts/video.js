var modal = document.getElementById('custom-video-modal');
var video = document.getElementById('custom-video-player');
var watchBtn = document.getElementById('custom-watch-video');

function closeModal() {
  modal.style.display = 'none';
  video.pause();
  video.currentTime = 0;
}

watchBtn.addEventListener('click', function (e) {
  e.preventDefault();
  e.stopPropagation();

  modal.style.display = 'block';
  video.currentTime = 0;

  var playPromise = video.play();
  if (playPromise !== undefined) {
    playPromise.catch(function (err) {
      console.error('Play error:', err.name, err.message);
    });
  }
});

// Close only when clicking the dark backdrop
modal.addEventListener('click', function (e) {
  if (e.target === modal) {
    closeModal();
  }
});

