-- affine_persistence_schema.sql
-- Integer-only 8D manifold tables for peer review. No connection pool. No host DSN.
-- Coordinates are mill/micro integers. Rationals are num/den TEXT.

CREATE TABLE IF NOT EXISTS manifold_coordinate (
  id INTEGER PRIMARY KEY,
  study_id INTEGER NOT NULL,
  axis TEXT NOT NULL CHECK (axis IN ('s1','s2','s3','s4','c1','c2','c3','c4')),
  milli INTEGER NOT NULL,
  CHECK (typeof(milli) = 'integer')
);

CREATE TABLE IF NOT EXISTS ehrhart_coefficient (
  polytope_id TEXT NOT NULL,
  dilation INTEGER NOT NULL,
  lattice_count INTEGER NOT NULL,
  volume_num INTEGER NOT NULL,
  volume_den INTEGER NOT NULL,
  PRIMARY KEY (polytope_id, dilation),
  CHECK (volume_den > 0)
);

CREATE TABLE IF NOT EXISTS qpr_round_state (
  rounds INTEGER PRIMARY KEY,
  win_num INTEGER NOT NULL,
  win_den INTEGER NOT NULL,
  bound_num INTEGER NOT NULL,
  bound_den INTEGER NOT NULL,
  CHECK (win_den > 0 AND bound_den > 0)
);

CREATE TABLE IF NOT EXISTS connes_linking (
  word_id TEXT PRIMARY KEY,
  presentation TEXT NOT NULL,
  linking_q INTEGER NOT NULL,
  linking_r INTEGER NOT NULL,
  rigid_class TEXT NOT NULL
);
