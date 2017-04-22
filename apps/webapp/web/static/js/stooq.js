import socket from "./socket"

const channel = (function () {
    let channel = socket.channel("stooq:update", {});

    channel.on("update", payload => {
        console.log(payload);
    });

    channel.on("error", payload => {
        console.log(payload);
    });

    channel.join()
        .receive("ok", resp => { console.log("Joined successfully", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) });

    return channel;
})();

export default channel;