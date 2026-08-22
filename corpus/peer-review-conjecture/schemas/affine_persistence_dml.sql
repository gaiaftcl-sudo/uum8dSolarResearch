-- Aggregated polynomial coefficients / discrete finals (DML, no host paths)
INSERT INTO ehrhart_coefficient VALUES ('unit_square', 12, 169, 1, 1);
INSERT INTO ehrhart_coefficient VALUES ('unit_triangle', 12, 91, 1, 2);
INSERT INTO ehrhart_coefficient VALUES ('simplex3', 12, 455, 1, 6);
INSERT INTO ehrhart_coefficient VALUES ('hle_poly_d2', 12, 169, 1, 1);
INSERT INTO ehrhart_coefficient VALUES ('hle_poly_d3', 12, 1469, 2, 3);
INSERT INTO qpr_round_state VALUES (1, 3, 4, 3, 4);
INSERT INTO qpr_round_state VALUES (2, 9, 16, 9, 16);
INSERT INTO qpr_round_state VALUES (4, 81, 256, 81, 256);
INSERT INTO qpr_round_state VALUES (8, 6561, 65536, 6561, 65536);
INSERT INTO connes_linking VALUES ('Z2_a2b', 'cyclicZ2', 0, 1, 'RIGID_CYCLE');
INSERT INTO connes_linking VALUES ('Z2_aba', 'cyclicZ2', 0, 1, 'RIGID_CYCLE');
INSERT INTO connes_linking VALUES ('Z2_abAB', 'freeAbelianZ2', 0, 0, 'RIGID_COMMUTATIVE');
INSERT INTO connes_linking VALUES ('Z2_ba', 'freeAbelianZ2', 1, 1, 'RIGID_TRANSLATION');
INSERT INTO connes_linking VALUES ('S3_abab', 'symmetricS3', 2, 2, 'RIGID_BOUNDED');
