/** Named client tools (28 tools synced with /v1/mcp). */
(function (global) {
  "use strict";
  var names = ["feeds_catalog", "verify_grover", "solve_shear_closure", "affine_bench04_swebench_ast_gate", "affine_bench05_gaia_taubench_pass8", "affine_shield1_metamath_and_physics", "affine_shield1_physics_rotor", "affine_shield1_metamath_prover", "affine_shield2_health_biotwin", "affine_shield2_health_diagnostic", "affine_shield3_global_cluster_and_crypto_hunter", "affine_shield3_civic_unmasker", "affine_shield3_kinetic_counter_shear", "affine_shield3_live_cluster_hunter", "affine_shield4_matter_cif_inverter", "affine_shield5_atc_windshear_rss", "affine_shield5_worldwide_weather_atc_eids", "affine_shield5_avs8d_street_video", "affine_shield6_finance_bogle_and_energy_inflation", "affine_shield6_finance_bogle_audit", "affine_shield6_energy_inflation_audit", "affine_shield6_tokenized_equity_audit", "affine_shield7_allsouls_500_proof", "affine_shield7_allsouls_proof", "affine_shield8_robotics_6domain_airlock", "affine_shield8_robotics_airlock", "affine_shield9_silicon_highna_euv", "affine_shield9_silicon_euv_lock"];
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
