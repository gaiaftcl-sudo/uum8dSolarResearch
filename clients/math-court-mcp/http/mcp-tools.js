/** Named client tools — fetch only. Generated from live tools/list. */
(function (global) {
  "use strict";
  var names = ["atc.assert_4d_deconfliction", "corpus_bonds", "critique_frame", "execute_transition", "feeds_catalog", "game_frame_meta", "ide_rebuild_mesh", "membrane_health", "noaa_goes_r_weather", "twin.robotics.evaluate_exact_ik", "umc_direct", "umc_resume", "umc_status", "verify_jordan_bond", "weather.convective_containment"];
  function ident(n) { return n.replace(/[.-]/g, "_"); }
  var host = global.AffineEarthMathCourt || {};
  host.toolNames = names;
  names.forEach(function (n) {
    host[ident(n)] = function (args) {
      return host.toolsCall(n, args || {});
    };
  });
  global.AffineEarthMathCourt = host;
})(typeof window !== "undefined" ? window : globalThis);
