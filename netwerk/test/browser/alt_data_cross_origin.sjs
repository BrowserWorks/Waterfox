"use strict";

// A small, cacheable JavaScript resource used by
// browser_alt_data_cross_origin.js. It is loaded cross-origin as a script by
// two different origins, which must not share each other's alt-data (bytecode).
function handleRequest(request, response) {
  response.setHeader("Content-Type", "application/javascript", false);
  response.setHeader("Cache-Control", "max-age=86400", false);
  response.write("var original = 1;\n");
}
