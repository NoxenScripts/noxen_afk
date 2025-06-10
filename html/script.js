let timerInterval;
let currentMessage = "";
let currentReward = "";

window.addEventListener('message', function(event) {
    let item = event.data;

    if (item.type === "showTimer") {
        const timerElement = document.getElementById('afk-timer');
        
        if (item.position) {
            timerElement.style.bottom = item.position.bottom;
            timerElement.style.left = item.position.left;
        }
        
        currentMessage = item.message;
        currentReward = item.reward;
        
        updateTexts();
        
        timerElement.classList.add('visible');
        startTimer(item.duration);
    } else if (item.type === "hideTimer") {
        document.getElementById('afk-timer').classList.remove('visible');
        if (timerInterval) {
            clearInterval(timerInterval);
        }

    } else if (item.type === "fadeOut") {
        fadeOut();
    } else if (item.type === "fadeIn") {
        fadeIn();
    }
});

function updateTexts() {
    const zoneText = document.querySelector('.zone-text');
    const timerLabel = document.querySelector('.timer-label');
    
    if (zoneText && currentMessage) {
        zoneText.textContent = currentMessage;
    }
    if (timerLabel && currentReward) {
        timerLabel.textContent = currentReward;
    }
}

function startTimer(duration) {
    let timer = duration;
    if (timerInterval) {
        clearInterval(timerInterval);
    }

    function updateTimer() {
        let minutes = parseInt(timer / 60, 10);
        let seconds = parseInt(timer % 60, 10);

        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        document.querySelector('.timer-countdown').textContent = minutes + ":" + seconds;

        updateTexts();

        if (--timer < 0) {
            timer = duration;
        }
    }

    updateTimer();
    timerInterval = setInterval(updateTimer, 1000);
}

function fadeOut() {
    const overlay = document.getElementById('fade-overlay');
    overlay.style.opacity = '1';
}

function fadeIn() {
    const overlay = document.getElementById('fade-overlay');
    overlay.style.opacity = '0';
} 