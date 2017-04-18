(function () {
    "use strict";

    const express = require('express');
    const app = express();

    const SAMPLE_RESPONSE = "Symbol,Data,Czas,Otwarcie,Najwyzszy,Najnizszy,Zamkniecie\r\n\
Index,2017-04-18,10:01:00,58939.48,59223.25,58939.48,59025.43\r\n";

    const ERR_RESPONSE = "Przekroczono limit zadan.";

    app.get("/q/l", (req, res) => {
        res.send(SAMPLE_RESPONSE);
    });

    app.listen(3000, function () {
        console.log("Mock listening on port 3000!");
    });
}());