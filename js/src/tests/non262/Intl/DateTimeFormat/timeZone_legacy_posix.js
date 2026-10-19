// |reftest| skip-if(!this.hasOwnProperty("Intl")) -- Requires ICU time zone support

// The legacy POSIX-style time zones are aliases for the corresponding city time
// zones. They aren't exposed as canonical time zone identifiers, and use the
// time zone rules and localized names of the city time zones.
//
// See <https://github.com/tc39/ecma402/issues/1103>.

const legacyZones = {
    "CST6CDT": "America/Chicago",
    "EST5EDT": "America/New_York",
    "MST7MDT": "America/Denver",
    "PST8PDT": "America/Los_Angeles",
};

const supported = Intl.supportedValuesOf("timeZone");

// Dates before and after the transition to the modern US time zone rules.
const dates = [new Date(Date.UTC(1850, 0, 1))];
for (let year = 1900; year <= 2040; year += 4) {
    for (let month = 0; month < 12; month++) {
        dates.push(new Date(Date.UTC(year, month, 15, 12)));
    }
}

for (let [legacy, city] of Object.entries(legacyZones)) {
    // Canonicalization of the time zone identifier.
    for (let id of [legacy, legacy.toLowerCase()]) {
        let options = new Intl.DateTimeFormat("en-US", {timeZone: id}).resolvedOptions();
        assertEq(options.timeZone, city);
    }

    // Not exposed as supported time zone identifiers.
    assertEq(supported.includes(legacy), false);
    assertEq(supported.includes(city), true);

    // Localized time zone names and time zone offsets match the city.
    for (let timeZoneName of ["long", "short", "longGeneric", "longOffset"]) {
        let legacyDTF = new Intl.DateTimeFormat("en-US", {timeZone: legacy, timeZoneName});
        let cityDTF = new Intl.DateTimeFormat("en-US", {timeZone: city, timeZoneName});
        for (let date of dates) {
            assertEq(legacyDTF.format(date), cityDTF.format(date));
        }
    }

    if (typeof Temporal !== "undefined") {
        for (let date of dates) {
            let iso = date.toISOString().slice(0, 19);
            let legacyZDT = Temporal.ZonedDateTime.from(`${iso}[${legacy}]`);
            let cityZDT = Temporal.ZonedDateTime.from(`${iso}[${city}]`);
            assertEq(legacyZDT.offset, cityZDT.offset);
            assertEq(legacyZDT.epochNanoseconds, cityZDT.epochNanoseconds);
            assertEq(legacyZDT.equals(cityZDT), true);
        }
    }
}

if (typeof reportCompare === "function")
    reportCompare(0, 0, "ok");
