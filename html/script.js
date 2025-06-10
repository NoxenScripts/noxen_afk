let timerInterval;

window.addEventListener('message', function(event) {
    let item = event.data;

    if (item.type === "showTimer") {
        document.getElementById('afk-timer').classList.add('visible');
        startTimer(item.duration);
    } else if (item.type === "hideTimer") {
        document.getElementById('afk-timer').classList.remove('visible');
        if (timerInterval) {
            clearInterval(timerInterval);
        }
    } else if (item.type === "showReward") {
        showReward(item.amount, item.rewardType);
    } else if (item.type === "fadeOut") {
        fadeOut();
    } else if (item.type === "fadeIn") {
        fadeIn();
    }
});

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

        if (--timer < 0) {
            timer = duration;
        }
    }

    updateTimer();
    timerInterval = setInterval(updateTimer, 1000);
}

function showReward(amount, type) {
    const rewardText = document.querySelector('.reward-text');
    rewardText.textContent = `+ ${amount}$ ${type === 'money' ? 'en espèces' : 'en banque'}`;
    rewardText.classList.remove('show');
    
    void rewardText.offsetWidth;
    
    rewardText.classList.add('show');
    
    setTimeout(() => {
        rewardText.classList.remove('show');
    }, 3000);
}

function fadeOut() {
    const overlay = document.getElementById('fade-overlay');
    overlay.style.opacity = '1';
}

function fadeIn() {
    const overlay = document.getElementById('fade-overlay');
    overlay.style.opacity = '0';
} 