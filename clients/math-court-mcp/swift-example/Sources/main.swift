import Foundation

/// Public example: call the live Glama / affine.earth math court.
/// Law lives on the cell. This process posts decimal strings and prints LIVE/LEARN.

enum Apex {
    static let url = URL(string: "https://affine.earth/language-invariant/mcp")!

    static func call(_ method: String, params: [String: Any]) async throws -> [String: Any] {
        let body: [String: Any] = [
            "jsonrpc": "2.0", "id": 1, "method": method, "params": params,
        ]
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONSerialization.data(withJSONObject: body)
        req.timeoutInterval = 20
        let (data, resp) = try await URLSession.shared.data(for: req)
        if let http = resp as? HTTPURLResponse, http.statusCode != 200 {
            throw NSError(domain: "apex", code: http.statusCode)
        }
        guard let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError(domain: "apex", code: 1)
        }
        return obj
    }

    static func tool(_ name: String, _ arguments: [String: Any] = [:]) async throws -> [String: Any] {
        let env = try await call("tools/call", params: ["name": name, "arguments": arguments])
        if let result = env["result"] as? [String: Any] {
            if let sc = result["structuredContent"] as? [String: Any] { return sc }
            return result
        }
        throw NSError(domain: "apex", code: 2)
    }
}

@main
struct AffineMathCourtMCP {
    static func main() async {
        var live = 0
        var learn = 0

        func row(_ id: String, _ ok: Bool, _ detail: String) {
            print("\(ok ? "LIVE " : "LEARN")  \(id)  \(detail)")
            if ok { live += 1 } else { learn += 1 }
        }

        do {
            let env = try await Apex.call("tools/list", params: [:])
            let tools = ((env["result"] as? [String: Any])?["tools"] as? [[String: Any]]) ?? []
            let names = tools.compactMap { $0["name"] as? String }
            let leaked = ["mine", "isolate", "sha256d", "submitblock", "nphard"]
                .filter { names.contains($0) }
            row("tools/list", leaked.isEmpty && names.contains("math_court"),
                "n=\(names.count) leaked=\(leaked)")
        } catch {
            row("tools/list", false, "\(error)")
        }

        let courts: [(String, String, [String: String])] = [
            ("geometry", "cad_engineer", ["polytope_id": "unit_square", "dilation": "12"]),
            ("chance", "consensus", ["rounds": "8"]),
            ("algebra", "phenomenologist", ["word": "Z2_a2b"]),
            ("physics", "theorist", ["clock": "1", "track": "1"]),
            ("qcd", "phenomenologist", ["q_bin": "1", "dilation_t": "1"]),
            ("health", "clinician", ["mass_milli": "19000", "vol_milli": "20000"]),
            ("finance", "trader", ["lots": "3", "ticks": "5"]),
            ("cs", "compiler", ["num": "143", "den": "1"]),
            ("fluids", "designer", ["phi_in": "8", "phi_out": "8"]),
            ("eclipse", "steward", ["obscuration_ppm": "900000", "depletion_ppm": "300000"]),
            ("eht", "detector", ["short_median_ujy": "1500000", "long_median_ujy": "400000", "ratio_ppt": "5000"]),
            ("seismic", "station", ["travel_s": "53", "snr_ppt": "20000"]),
            ("disease", "clinician", ["icd": "E11", "doid": "DOID:9352"]),
            ("chemistry", "steward", ["inchikey": "BSYNRYMUTXBXSQ-UHFFFAOYSA-N", "cid": "2244"]),
            ("material", "steward", ["cod": "1011097"]),
            ("pdb", "steward", ["pdb_id": "1CRN"]),
            ("rife", "steward", ["hz": "440", "cited_id": "iso16-a440"]),
            ("dynamo", "steward", ["q": "0", "r": "1", "n": "1", "d": "2", "cited_id": "z2-a2b-half-step"]),
            ("qma_2local", "researcher", ["constraints": "0,1,1,1", "config": "0,1"]),
            ("qma_spinglass", "researcher", ["edges": "0,1,1;1,2,1;2,0,1", "spins": "1,-1,1"]),
            ("qma_nrep", "researcher", ["rho2": "1/2,0/1|0/1,1/2", "n": "2"]),
            ("qma_permanent", "researcher", ["matrix": "1,1,1|1,1,1|1,1,1"]),
        ]

        do {
            let cat = try await Apex.tool("math_court", [:])
            let n = cat["domain_count"] as? Int ?? 0
            row("math_court catalog", n >= 20, "domains=\(n)")
        } catch {
            row("math_court catalog", false, "\(error)")
        }

        for (domain, role, body) in courts {
            do {
                var args: [String: Any] = ["domain": domain, "role": role, "source": "glama:example"]
                for (k, v) in body { args[k] = v }
                let r = try await Apex.tool("math_court", args)
                let status = (r["status"] as? String) ?? ""
                row("court:\(domain)", !status.hasPrefix("REFUSED"),
                    "status=\(status) verdict=\(r["verdict"] ?? "")")
            } catch {
                row("court:\(domain)", false, "\(error)")
            }
        }

        let qma: [(String, [String: String], String)] = [
            ("execute_2local_hamiltonian", ["constraints": "0,1,1,1", "config": "0,1"], "-1"),
            ("route_spin_glass_manifold", ["edges": "0,1,1;1,2,1;2,0,1", "spins": "1,-1,1"], "-1"),
            ("verify_n_representability", ["rho2": "1/2,0/1|0/1,1/2", "n": "2"], "1"),
            ("execute_exact_permanent", ["matrix": "1,1,1|1,1,1|1,1,1"], "6"),
        ]
        for (name, args, expect) in qma {
            do {
                let r = try await Apex.tool(name, args)
                let e = "\(r["energy_num"] ?? "")"
                row("qma:\(name)", r["ok"] as? Bool == true && e == expect,
                    "\(r["verdict"] ?? "") E=\(e)")
            } catch {
                row("qma:\(name)", false, "\(error)")
            }
        }

        do {
            let j = try await Apex.tool("verify_jordan_bond", [
                "A": "1,1,1,1,1,1,1,1|1",
                "B": "1,1,1,1,1,1,1,1|1",
                "K": "3,-2,5,1,7,1,4,2|1",
            ])
            row("verify_jordan_bond",
                j["admitted"] as? Bool == true && (j["proven"] as? String) == "AFFINE_JZ_SHEAR_ZERO",
                (j["proven"] as? String) ?? "")
        } catch {
            row("verify_jordan_bond", false, "\(error)")
        }

        print("GLAMA \(live) LIVE · \(learn) LEARN of \(live + learn)")
        if learn > 0 { exit(2) }
    }
}
