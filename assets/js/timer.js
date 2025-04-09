/**
 * @type {import("phoenix_live_view").ViewHookInterface}
 */
export const TimerDisplay = {
    mounted() {
        this.timer = new Timer(this);
    },

    updated() {
        this.timer.sync();
    },

    destroyed() {
        this.timer.teardown();
    }
};

/**
 * @constructor
 * @param {import("phoenix_live_view").ViewHookInterface} hook - The hook instance
 */
function Timer(hook) {
    let _interval = null;
    let _startTime = null;

    sync();

    function sync() {
        const startTime = parseInt(hook.el.dataset.startTime, 10) || null;
        _startTime = startTime > 0 ? startTime : null;
        _startTime !== null ? start() : stop();
    }

    function start() {
        if (_interval) {
            return;
        }
        
        
        _interval = setInterval(updateTimer, 1000);
    }

    function stop() {
        if (!_interval) {
            return;
        }

        clearInterval(_interval);
        _interval = null;
    }

    function updateTimer() {
        if (!_startTime) {
            return;
        }

        const { hours, minutes, seconds } = getTimePassed();
        const formattedTime = `${withLeadingZero(hours)}:${withLeadingZero(minutes)}:${withLeadingZero(seconds)}`;
        hook.el.innerText = formattedTime;
    }

    function getTimePassed() {
        const secondsPassed = Date.now() - _startTime;
        const hours = Math.floor(secondsPassed / 3600000);
        const minutes = Math.floor((secondsPassed % 3600000) / 60000);
        const seconds = Math.floor((secondsPassed % 60000) / 1000);

        return { hours, minutes, seconds };
    }

    function withLeadingZero(number) {
        return String(number).padStart(2, '0');
    }

    function teardown() {}

    return { sync, teardown };
}