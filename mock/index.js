(function () {
    "use strict";

    const express = require('express');
    const format = require('string-format')
    const app = express();

    const SAMPLE_RESPONSE = "Symbol,Data,Czas,Otwarcie,Najwyzszy,Najnizszy,Zamkniecie\r\n\
Index,2017-04-18,10:01:00,58939.48,59223.25,58939.48,{}\r\n";

    //should be used to emulate stooq errors
    const ERR_RESPONSE = "Przekroczono limit zadan.";

    let random_value = () => (Math.random() * 100000).toFixed(2);

    app.get("/q/l", (req, res) => {
        res.send(format(SAMPLE_RESPONSE, random_value()));
    });

    app.listen(3000, function () {
        console.log("Mock listening on port 3000!");
    });
}());