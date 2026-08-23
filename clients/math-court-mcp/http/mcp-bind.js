/**
 * Affine.Earth Math Court — browser bind.
 *
 * Fetch only. No lattice arithmetic. No SCF. No volume.
 * The cell at affine.earth is the court.
 */
(function (global) {
  "use strict";
  var APEX = "https://affine.earth";
  var MCP = APEX + "/language-invariant/mcp";
  var rpcId = 1;

  function post(url, payload) {
    return fetch(url, {
      method: "POST",
      credentials: "omit",
      referrerPolicy: "no-referrer",
      headers: { "content-type": "application/json", accept: "application/json" },
      body: JSON.stringify(payload),
    }).then(function (res) {
      return res.json().then(function (body) {
        return { http: res.status, body: body };
      });
    });
  }

  function mcp(method, params) {
    var msg = { jsonrpc: "2.0", id: "bind-" + rpcId++, method: method };
    if (params) msg.params = params;
    return post(MCP, msg);
  }

  function courtIngest(domain, claim) {
    return post(APEX + "/language-invariant/game/" + domain + "/ingest", claim);
  }

  global.AffineEarthMathCourt = {
    apex: APEX,
    mcp: mcp,
    toolsList: function () {
      return mcp("tools/list");
    },
    toolsCall: function (name, arguments_) {
      return mcp("tools/call", { name: name, arguments: arguments_ || {} });
    },
    courtIngest: courtIngest,
  };
})(typeof window !== "undefined" ? window : globalThis);
