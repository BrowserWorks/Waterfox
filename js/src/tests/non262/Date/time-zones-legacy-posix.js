// |reftest| skip-if(winWidget||!this.hasOwnProperty("Intl")) -- Windows doesn't accept IANA names for the TZ env variable; Requires ICU time zone support

// The legacy POSIX-style time zones are aliases for the corresponding city time
// zones when used as the default time zone.
//
// See <https://github.com/tc39/ecma402/issues/1103>.

const legacyZones = {
    "CST6CDT": "America/Chicago",
    "EST5EDT": "America/New_York",
    "MST7MDT": "America/Denver",
    "PST8PDT": "America/Los_Angeles",
};

const dates = [new Date(Date.UTC(1850, 0, 1))];
for (let year = 1900; year <= 2040; year += 4) {
    for (let month = 0; month < 12; month++) {
        dates.push(new Date(Date.UTC(year, month, 15, 12)));
    }
}

function describe(tz) {
    let result;
    inTimeZone(tz, () => {
        result = {
            id: new Intl.DateTimeFormat().resolvedOptions().timeZone,
            dates: dates.map(date => [date.toString(), date.getTimezoneOffset()]),
        };
    });
    return result;
}

for (let [legacy, city] of Object.entries(legacyZones)) {
    let legacyResult = describe(legacy);
    assertEq(legacyResult.id, city);
    assertEqArray(legacyResult.dates.flat(), describe(city).dates.flat());
}

if (typeof reportCompare === "function")
    reportCompare(0, 0, "ok");
