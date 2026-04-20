# QOMN v3.2 — Preprint Artifact

**An Open-Source Domain-Specific Language and JIT Runtime for Verifiable, Deterministic Computation.**

**Author:** Percy Rojas Masgo — Condesi Perú / Qomni AI Lab
**Contact:** percy.rojas@condesi.pe
**License:** Paper text MIT · QOMN runtime Apache-2.0
**Status:** Preprint v1.0 — April 2026

[Live Demo](https://desarrollador.xyz/benchmark.html) · [Paper source](paper/main.tex) · [Runtime source](https://github.com/condesi/qomn)

QOMN is the deterministic execution kernel of the **Qomni Cognitive OS**. It compiles any closed-form, citation-bearing formula (engineering, clinical, legal, financial, scientific) to native x86-64 via Cranelift JIT, producing bit-exact results for identical inputs. **The architecture imposes no ceiling on the number of plans:** the 57 plans currently shipped in the standard library are a validation sample across 10 engineering domains, not the intended final scope. The target is thousands of plans across specialized domain libraries, contributed by certified professionals against their governing standards.

This repository is the public preprint artifact: full paper (LaTeX + bibliography), language specification, reproducibility and installation scripts, initial standard library, and benchmark data.

---

## 📄 This Repository

This is the **public preprint artifact** for the QOMN paper. It contains:

- **`paper/main.tex`** — Full preprint (~22 pages, 13 sections, 17 references).
- **`paper/legacy/`** — Earlier paper versions kept for historical reference.
- **`LANGUAGE_SPEC.md`** — Complete QOMN v2 language specification (EBNF, type system, semantics).
- **`ORIGINALITY.md`** — Statement of originality and novelty claims.
- **`stdlib/`** — 11 engineering domain libraries (`.qomn` source).
- **`examples/`** — Hands-on example plans.
- **`runtime/integration_guide.md`** — Integration guide for runtime consumers.
- **`scripts/reproduce.sh`** — Verify every numerical claim in the paper against the live API.
- **`scripts/install.sh`** — Build the QOMN runtime locally for offline reproduction.
- **`scripts/benchmark.sh`** — Run benchmark suite.
- **`data/benchmarks/`** — Raw JSON benchmark results.
- **`AUTHORS.md`**, **`CITATION.cff`**, **`CHANGELOG.md`**, **`CONTRIBUTING.md`**, **`CODE_OF_CONDUCT.md`** — Standard project metadata.

The runtime implementation lives at [`condesi/qomn`](https://github.com/condesi/qomn).
The legacy language repository is [`condesi/crysl-lang`](https://github.com/condesi/crysl-lang) (archived).

---

> Write an engineering calculation once. Get **exact answers** in **nanoseconds on the JIT hot path**,
> with the standard and formula cited. No LLM. No approximation. No setup.

---

## Quick Start — Try It Now

**Online (browser, no install):**
👉 [desarrollador.xyz/benchmark.html](https://desarrollador.xyz/benchmark.html)

```
plan_pump_sizing(500, 100, 0.75)
→ Required HP:  16.84 HP  [NFPA 20:2022 §4.26]
→ Shutoff HP:   23.57 HP
→ Latency:      5.37 ns JIT hot path (L4 Register ABI)
→ HTTP:         ~2–4 ms loopback/API path
```

---

## Why QOMN?

| Question | LLM (GPT-4 Turbo) | QOMN v2.3 JIT |
|----------|-------------------|-----------------|
| "500 gpm pump at 100 psi, 75% eff — HP?" | ~17 HP (approximate) | **16.835 HP** (deterministic) |
| Standard cited? | Not guaranteed | NFPA 20:2022 §4.26 |
| Hot-path latency | ~12 s API-class response | **5.37 ns** measured JIT hot path |
| API loopback latency | seconds | **~2–4 ms** TCP + HTTP parse overhead |
| Reproducible? | No (stochastic) | Yes (deterministic) |
| Works offline? | No | Yes |
| Cost per call | API/token cost | **Free local execution** |

**Measured on Server5 KVM AMD EPYC, 2026-04-19 (live):** QOMN v3.2 executes selected engineering plans in **5.37–10.69 ns** on the JIT hot path. The simulation engine sustains **396M scenarios/sec** on the same KVM host.

---

## Benchmark Results (Server5, KVM AMD EPYC · 12-core · 48 GB · Ubuntu 24.04)

> Real measured numbers, 2026-04-19 (live). JIT hot-path values use the L4 Register ABI and exclude HTTP/TCP overhead.
> API loopback adds approximately **2–4 ms** from TCP, HTTP parsing, JSON serialization, and routing.

| Workload | Measured Result | Notes |
|------|------:|------|
| Fire Pump Sizing | **5.37 ns** | JIT L4 Register ABI hot path |
| Sprinkler System | **9.67 ns** | JIT L4 Register ABI hot path |
| Beam Analysis | **10.69 ns** | JIT L4 Register ABI hot path |
| OracleCache | **~12 ns** | FNV-1a measured cache probe |
| Simulation Engine | **396M scenarios/sec** | KVM AMD EPYC, continuous SoA loop |
| Simulation valid fraction | **72.1%** | Physics validation enabled |
| Simulation Pareto size | **507** | Multi-objective Pareto frontier |
| HTTP Loopback | **~2–4 ms** | TCP + HTTP parse/API overhead |

Full data: [`benchmarks/results_2026-04-19 (live).json`](benchmarks/results_2026-04-19 (live).json)

---

## Paper-Grade Benchmarks

### Methodology

- Hardware: Server5 KVM AMD EPYC · 12 cores · 48GB RAM · Contabo VPS · Ubuntu 24.04 LTS
- Runtime: QOMN v3.2 · Rust release build · Cranelift native x86-64 JIT · L4 Register ABI
- Hot-path metric: measured nanoseconds, HTTP excluded
- API metric: measured HTTP loopback path, including TCP + HTTP parse overhead
- Simulation metric: continuous SoA AVX2 loop with physics validation and Pareto ranking

### Results

| Benchmark | Result |
|---|---:|
| `plan_pump_sizing` | **5.37 ns** |
| `plan_sprinkler_system` | **9.67 ns** |
| `plan_beam_analysis` | **10.69 ns** |
| OracleCache FNV-1a probe | **~12 ns** |
| Simulation throughput | **396M scenarios/sec** |
| Valid fraction | **72.1%** |
| Pareto frontier size | **507** |
| HTTP loopback | **~2–4 ms** |

> Note: older paper drafts referenced an **86.4M scenarios/sec** simulation figure from an earlier benchmark methodology. The current reproducible Server5 KVM measurement is **396M scenarios/sec** and should be treated as the authoritative v3.2 number.

### Why QOMN vs C++/Rust?

Pure C++/Rust achieve excellent raw arithmetic performance, but QOMN adds:
- **Standards traceability** — every formula cites NFPA/IEC/ISO
- **Physics validation** — inputs and outputs checked against domain bounds
- **Multi-objective optimization** — Pareto-ranked scenario sweeps
- **Domain constants** — documented engineering constants instead of hidden magic numbers
- **Autonomous simulation loop** — `POST /simulation/start` runs continuous validation/optimization

### Real Case: ACI Fire System Optimization

See [`examples/aci_optimizado_completo.qomn`](examples/aci_optimizado_completo.qomn) for a complete multi-plan optimization of a 5-floor office building fire suppression system with:
- NFPA 13-2022 sprinkler demand constraints
- NFPA 20-2022 pump selection rules
- Annual energy cost model
- Multi-objective Pareto: safety margin vs cost vs energy

Full baseline data: [`benchmarks/baseline_comparison_2026-04-19 (live).json`](benchmarks/baseline_comparison_2026-04-19 (live).json)

---

## How It Works

QOMN describes *what to compute*, not how. The runtime compiles each plan via Cranelift JIT
to native x86-64 machine code and executes the hot path through the L4 Register ABI:

```
User/API call → route → parse params → plan dispatch → JIT hot path → result
   HTTP         ms        µs-ms          ns-µs          5–11 ns      output
```

**OracleCache:** FNV-1a hash on all inputs — repeated identical calls measure approximately **12 ns** for cache probe/lookup on Server5 KVM.

Compare to LLM: tokenize → model inference → autoregressive decode → seconds → approximate answer.

---

## Write a Plan in 20 Lines

```qomn
plan_pump_sizing(
    Q_gpm: f64,           // required flow (GPM)
    P_psi: f64,           // required pressure (PSI)
    eff:   f64 = 0.70     // pump efficiency (0–1)
) {
    meta {
        standard: "NFPA 20:2022",
        source: "Section 4.26 + Chapter 6",
        domain: "fire",
    }

    let Q_lps  = Q_gpm * 0.06309;
    let H_m    = P_psi * 0.70307;
    let HP_req = (Q_lps * H_m) / (eff * 76.04);
    let HP_max = HP_req * 1.40;   // NFPA 20: shutoff ≤ 140% rated

    formula "Pump HP": "HP = (Q[L/s] × H[m]) / (η × 76.04)";

    assert Q_gpm > 0.0 msg "flow must be positive";
    assert eff   <= 1.0 msg "efficiency must be ≤ 1.0";

    return { HP_req: HP_req, HP_max: HP_max, Q_lps: Q_lps, H_m: H_m };
}
```

---

## Standard Library (v3.2 — 10 Domains, 57 Plans — unbounded by design)

> **QOMN has no domain limit.** These 13 domains are the current stdlib.
> Any deterministic calculation expressible as a formula can become a QOMN plan.

### Fire Protection (NFPA)
`stdlib/nfpa_electrico.qomn`

| Plan | Formula | Standard |
|------|---------|---------|
| `plan_pump_sizing(Q_gpm, P_psi, eff)` | HP = Q·H/(η·76.04) | NFPA 20:2022 §4.26 |
| `plan_sprinkler_system(area_ft2, density, hose_stream)` | Q = area × density + hose | NFPA 13:2022 |
| `plan_hose_stream(class)` | Q_hose by occupancy class | NFPA 13 Table 11.2 |

### Hydraulics (IS.010 Peru / AWWA)
`stdlib/hidraulica.qomn`

| Plan | Formula | Standard |
|------|---------|---------|
| `plan_hazen_williams(Q, D, C, L)` | V = 0.8492·C·R^0.63·S^0.54 | IS.010 Peru / AWWA M22 |
| `plan_darcy_weisbach(Q, D, f, L)` | h_f = f·L/D·V²/2g | Darcy-Weisbach |
| `plan_pipe_sizing(Q, v_max)` | D = √(4Q/πv) | IS.010 Peru |

### Electrical (IEC 60364 / NEC 2023 / IEEE 141)
`stdlib/electrical.qomn`

| Plan | Formula | Standard |
|------|---------|---------|
| `plan_voltage_drop(I, L_m, A_mm2)` | ΔV = ρ·L·I/A, ρ=0.0172 Ω·mm²/m | IEC 60364-5-52 / NEC 2023 |
| `plan_electrical_3ph(P_kw, V, pf, L_m, A_mm2)` | I = P/(√3·V·pf), ΔV₃φ = √3·ρ·L·I/A | IEC 60364 / NEC / IEEE 141 |
| `plan_solar_pv(P_wp, irr_kwh, eff, area_m2)` | E_day = P·irr·eff | IEC 61724-1 |
| `plan_power_factor_correction(P_kw, pf_current, pf_target, V)` | Q_c = P·(tan φ₁ − tan φ₂) | IEC 60076 |

### Civil / Structural (AISC 360 / ACI 318 / ASCE 7)
`stdlib/civil.qomn`

| Plan | Formula | Standard |
|------|---------|---------|
| `plan_beam_analysis(P_kn, L_m, E_gpa, b_cm, h_cm)` | M = P·L/4, δ = P·L³/(48EI) | AISC 360-22 / ACI 318-19 |
| `plan_slope_stability(H_m, VH_ratio, c_kpa, tan_phi, gamma)` | FoS = τ_resist/τ_drive (Bishop) | ASCE 7-22 |
| `plan_column_capacity(b, h, fc, fy, rho)` | Pn = 0.85·f'c·Ac + fy·Ast | ACI 318-19 §22.4 |

### Financial (SUNAT / DL 728 Peru / NIIF)
`stdlib/financial.qomn`

| Plan | Formula | Standard |
|------|---------|---------|
| `plan_factura_peru(subtotal, igv_rate)` | Total = Subtotal × 1.18 | TUO IGV DL 821 / SUNAT |
| `plan_planilla_dl728(sueldo, meses_trabajo, dias_vacac)` | Neto = Bruto − ONP(13%), CTS = 1/12·Bruto | DL 728 / DL 713 / DL 19990 |
| `plan_van_roi(inversion, flujo_anual, tasa, anos)` | VAN = −I + F·[(1−(1+r)^−n)/r] | NIIF NIC 36 |
| `plan_loan_amortization(P, r_monthly, n_months)` | C = P·r·(1+r)ⁿ/((1+r)ⁿ−1) | Sistema Francés / SBS 2024 |

### Medical / Clinical (EN 285 / ISO 17665 / WHO)
`stdlib/medical.qomn`

> ⚠️ QOMN medical results are decision-support only. All clinical calculations must be reviewed by a licensed professional.

| Plan | Formula | Standard |
|------|---------|---------|
| `plan_autoclave_cycle(T_c, t_hold_min, D_value_min, vol_l, P_bar)` | F₀ = t·10^((T−121)/10) | EN 285:2015 / ISO 17665-1 |
| `plan_bmi_assessment(weight_kg, height_m, age)` | BMI = kg/m², BSA (Mosteller), IBW (Devine) | WHO 2000 / MINSA Peru |
| `plan_drug_dosing(weight_kg, dose_mg_per_kg, frequency_per_day)` | Dose = weight × mg/kg | WHO EML 2008 |

### Statistics (ISO 3534 / ASTM E2586)
`stdlib/statistics.qomn`

| Plan | Formula | Standard |
|------|---------|---------|
| `plan_statistics(n, sum_x, sum_x2)` | x̄, s² (Bessel), SEM, 95% CI, CV% | ISO 3534-1:2006 / ASTM E2586 |
| `plan_sample_size(confidence, margin, proportion, population)` | n₀ = z²·p(1−p)/e², FPC correction | ISO 3534-2 / Cochran 1977 |

### Transport & Logistics (MTC Peru / IPCC)
`stdlib/transport.qomn`

| Plan | Formula | Standard |
|------|---------|---------|
| `plan_logistics_cost(distance_km, cost_per_km, n_trips, units_per_trip, load_factor)` | C_unit = Total / (trips·units·LF) | MTC D.S. 017-2009-MTC |
| `plan_fuel_cost(distance_km, consume_l_100, fuel_price)` | Cost = gallons × price | OSINERGMIN 2024 |

### Hydraulics — Sanitary (IS.010 Peru)
`stdlib/sanitaria.qomn`

| Plan | Formula | Standard |
|------|---------|---------|
| `plan_water_demand(units, liters_per_unit, peak_factor)` | Q = units × dotación × K2 | IS.010 Peru §2.2 |
| `plan_cistern_volume(demand_lpd, days, safety)` | V = Q_daily × days × safety | IS.010 Peru §3.1.4 |
| `plan_drainage_pipe(flow_lps, slope, n_roughness)` | D = [Q·n·4^(2/3) / ((π/4)·S^(1/2))]^(3/8) | IS.010 §6.2 / Manning |

### Mechanical (ISO / ASME / AGMA)
`stdlib/mecanica.qomn`

| Plan | Formula | Standard |
|------|---------|---------|
| `plan_shaft_power(torque_nm, rpm)` | P = τ × ω = τ × 2π·n/60 | ISO 1:2016 / ISO 14691 |
| `plan_belt_drive(P_kw, v_ms, tension_ratio)` | F_eff = P/v; T1 = T2 × ratio | ISO 22:2012 / ASME B17.1 |
| `plan_gear_ratio(n_input, n_output, T_input_nm)` | T_out = T_in × (n_in/n_out) | AGMA 2001-D04 / ISO 6336 |

### Thermal / HVAC (ISO 6946 / ASHRAE)
`stdlib/termica.qomn`

| Plan | Formula | Standard |
|------|---------|---------|
| `plan_heat_load(area_m2, delta_t, u_value)` | Q = U × A × ΔT | ISO 6946:2017 |
| `plan_cop_heat_pump(T_hot_k, T_cold_k, eff)` | COP = η × T_hot / (T_hot − T_cold) | EN 14511:2018 / Carnot |
| `plan_cooling_load(area_m2, watt_per_m2, eff_factor)` | Q = area × W/m² × eff | ASHRAE 140-2017 |

---

## Grammar (EBNF)

```ebnf
program    ::= plan_decl+
plan_decl  ::= 'plan_' ident '(' params? ')' '{' body '}'
params     ::= param (',' param)*
param      ::= ident ':' type ('=' literal)?
type       ::= 'f64' | 'f32' | 'i64' | 'bool' | 'str'
body       ::= (const | let | formula | assert | return | meta)+
const      ::= 'const' ident '=' expr ';'
let        ::= 'let'   ident '=' expr ';'
formula    ::= 'formula' string ':' string ';'
assert     ::= 'assert' expr 'msg' string ';'
return     ::= 'return' '{' (ident ':' ident ',')* '}' ';'
meta       ::= 'meta' '{' (ident ':' string ',')+ '}'
expr       ::= term (('+' | '-' | '*' | '/' | '^') term)*
term       ::= number | ident | ident '(' args ')' | '(' expr ')'
```

Built-ins: `sqrt`, `pow`, `abs`, `min`, `max`, `clamp`, `log`, `log10`, `round`, `ceil`, `floor`, `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `atan2`, `pi`, `e`

---

## Repository Structure

```
qomn-lang/
├── SPEC.md                      # Full language specification
├── ORIGINALITY.md               # Language originality statement
├── LIMITATIONS.md               # Known limitations and safety boundaries
├── CHANGELOG.md                 # Version history
├── ROADMAP.md                   # Future milestones
├── paper/
│   ├── CRYSL_JIT_Paper_2026.md  # IEEE-style research paper
│   └── main.tex                 # LaTeX version
├── stdlib/
│   ├── hidraulica.qomn
│   ├── nfpa_electrico.qomn
│   ├── civil.qomn
│   ├── electrical.qomn
│   ├── financial.qomn
│   ├── medical.qomn
│   ├── statistics.qomn
│   ├── transport.qomn
│   ├── mecanica.qomn
│   ├── termica.qomn
│   └── sanitaria.qomn
├── runtime/
│   ├── interpreter.md
│   └── integration_guide.md
├── examples/
│   ├── hello_pump.qomn
│   ├── hello_hazen.qomn
│   └── hello_cable.qomn
├── benchmarks/
│   └── results_2026-04-19 (live).json  # v3.2 measured Server5 KVM data
└── README.md
```

---

## Contribute a Plan

1. Fork this repo
2. Write your plan in `stdlib/{domain}.qomn`
3. Add test vectors in `benchmarks/tests/{plan_name}.json`
4. Submit PR — all valid plans following the grammar are welcome

**Checklist:**
- [ ] `meta {}` with standard name + section reference
- [ ] `assert` for each input with meaningful error message
- [ ] `formula` for each key equation
- [ ] `return {}` or `output` with all computed values
- [ ] 3+ test cases from published reference tables

---

## Creator

**QOMN was designed and created by Percy Rojas Masgo** (Condesi Perú / Qomni AI Lab) in 2025–2026.

The language, grammar, compiler architecture, and standard library are original works.
No content has been adapted or copied from third-party tools, languages, or libraries.

Engineering formulas in the stdlib are mathematical laws in the public domain.
Standards (NFPA, IEC, ACI, IS.010, EN 285, DL 728) are cited by name and section number only —
consistent with academic reference practice. No text has been copied verbatim from any copyrighted
standards document.

---

## License

**Copyright (c) 2026 Percy Rojas Masgo — Condesi Perú / Qomni AI Lab**

QOMN language spec, grammar, standard library, examples: **MIT License**

The Qomni Engine runtime integration is proprietary.
The language itself — grammar, stdlib plans, this repo — is fully open.

See [LICENSE](LICENSE) for full terms and [ORIGINALITY.md](ORIGINALITY.md) for the complete originality statement.

---

## Open Language Initiative

QOMN is released as a fully open specification and implementation.

**License:** MIT — free use, modification, and integration into commercial systems.

**Objective:** Become the standard execution layer for deterministic AI computations.

**What QOMN enables:**
- Deterministic computation via Cranelift native JIT and L4 Register ABI
- Physics-as-Oracle (PaO): equations as primary source of truth
- OracleCache: FNV-1a measured cache probe around ~12 ns on Server5 KVM
- Exact, standard-referenced answers — no probabilistic approximation
- Continuous simulation engine: 396M scenarios/sec measured on Server5 KVM

**Important distinction:**
- QOMN (language, compiler, runtime, stdlib) — **open MIT**
- Qomni Engine (planner, learning loop, retrieval engine) — **proprietary**

Opening QOMN creates adoption. Keeping Qomni's cognitive engine closed preserves the architectural advantage.
Same model: Linux + cloud vendors, TensorFlow + Google, LLVM + Apple.

---

## Supporting Qomni

Qomni is an independent research effort advancing a new paradigm in AI systems:
**execution-first cognitive architectures that minimize unnecessary neural inference.**

> AI should think only when necessary. Everything else should be executed.

If you believe in a future where AI is faster, more efficient, less dependent on massive models,
and accessible everywhere — contribute to QOMN or reach out:
[percy.rojas@condesi.pe](mailto:percy.rojas@condesi.pe)

---


---

## Vision — What QOMN Is For

QOMN is built on a single premise: deterministic computation and stochastic inference are different problems, and they deserve different tools. The deterministic side — the tier that signs building drawings, computes drug doses, sizes fire pumps, calculates payroll — has been left with Excel, proprietary CAD, and LLMs that hallucinate.

QOMN is the deterministic tier, built for 2026 standards: open source, JIT-compiled, unit-typed, citation-bearing, verifiable, permissively licensed.

### Five design commitments

1. **Separation of thinking from executing.** QOMN is the executing layer; any orchestrator is the thinking layer. They communicate via stateless HTTP.
2. **No dependence on large language models.** QOMN performs no neural inference. Ships to offline edges, sandboxes, regulated deployments.
3. **Persistent deterministic memory as first-class concept** — provided by the orchestration layer consuming QOMN.
4. **Technical standards as machine-readable artifacts.** Every plan cites its governing standard (NFPA 20 §4.26, IEC 60364, AISC 360).
5. **Unlimited scalability across domains.** The architecture imposes **no upper bound on plan count**. It serves 57 plans today across 10 engineering domains as a validation sample; the target is **thousands of plans** across specialized libraries (clinical, legal, financial, aeronautical, pharmaceutical, nuclear, maritime, geotechnical), contributed by certified professionals in each field. Adding plans is an additive, distributed, community operation — no runtime changes required.

### Compact definition

> **Qomni is a cognitive operating system that orchestrates memory, models, and deterministic engines. QOMN is its core logical-execution engine — providing high-speed, verifiable computation that does not depend on probabilistic models.**

---


---

## What QOMN Unifies

The problem that motivates QOMN is **fragmentation**. Today, a single engineering or regulated workflow typically spans 5 to 8 different tools, each with its own semantics, versioning, and trust model:

| Fragmented today | Unified in QOMN |
|---|---|
| Excel / Google Sheets (undocumented cells, frozen formulas) | Plain-text plan with full grammar, version-controlled |
| Proprietary CAD/CAE calculation modules | Open-source, auditable compute at the same or higher speed |
| Interpreted Python or Julia scripts (non-deterministic across versions) | JIT-compiled to native code, bit-exact across runs |
| LLM API calls (stochastic, opaque, paid per token) | Deterministic call, free, microsecond-latency |
| Rule engines / decision tables (scattered across vendors) | First-class `plan` constructs with typed parameters |
| Hand-kept PDF standards (NFPA, IEC, AISC) | Each plan carries an inline citation to its governing clause |
| Separate unit-conversion libraries | Unit dimensions enforced by the type system |
| External validators (PDF review, email approval) | Compile-time + runtime checks embedded in the plan itself |
| Ad-hoc benchmark numbers in marketing material | Live public API with reproducibility script |
| Tribal knowledge ("Juan knows how we sized the pump") | Code signed by the engineer, diffable against the standard |

### The five unifications

1. **Calculation + citation.** A plan is simultaneously the code that produces the number and the reference to the standard that justifies it. You cannot separate the two; they live in the same file.

2. **Computation + verification.** Every result carries validation metadata (unit dimensions, physical range checks, adversarial input handling). You cannot run a plan without the safety checks running too.

3. **Source + reproducibility.** Every numerical claim in this paper is reproducible via `scripts/reproduce.sh` against either the public API or a local install. The paper and the runtime are not separate artifacts; they verify each other.

4. **Engineering + beyond.** The same language, runtime, and plan format serve engineering today and any other closed-form, citation-bearing domain tomorrow (clinical dosing, legal computation, financial reporting, scientific reduction). **Unified across domains** — no language variants per field.

5. **Execution + governance.** The deterministic execution layer (QOMN) and the orchestration layer (Qomni Cognitive OS, under development) share a stateless HTTP contract. The boundary is stable and minimal. You can replace either layer without breaking the other — a property typical of well-designed systems software, unusual in AI stacks.

### Why unification matters

Fragmentation is the largest silent cost in regulated computation. An engineer today spends more time reconciling outputs from different tools than thinking about the engineering itself. A reviewer spends more time verifying that the right version of the right standard was used than evaluating the design. A regulator spends more time on documentation format than on content.

By putting calculation, citation, verification, and reproducibility into a single versioned artifact, QOMN collapses that overhead. The engineer writes one plan; the reviewer reads one file; the regulator audits one trail. Every stage uses the same source of truth, and the source of truth is executable.

This is not a marketing promise. It is a consequence of the architectural choice to make the plan the central unit of work, with every other concern attached to it.


---

## Applications and Integration Patterns

QOMN is designed to serve as a **deterministic execution layer** in many different system shapes. This section sketches five integration patterns that cover most anticipated use cases, each with its own architecture diagram. These are design templates, not prescriptions; any team can adapt them.

### Pattern 1 - Backend Calculation Engine (ERP / SaaS / any existing app)

Use when an existing application needs auditable, citation-bearing formulas embedded in its business logic.

```
+------------------------+
|  Application frontend  |  (web, mobile, internal portal)
+-----------+------------+
            |  REST / JSON
+-----------v------------+
|  Business logic layer  |  (PHP, Node, Python, Java, .NET)
|  - Auth and sessions   |
|  - Data persistence    |
|  - Workflow state      |
+-----------+------------+
            |  HTTP POST /api/plan/execute
+-----------v------------+
|      QOMN runtime      |  <-- this paper
|  Deterministic compute |
+------------------------+
```

**Example:** a payroll module calls `plan_planilla(salary, contract_type, ...)` and receives bit-exact output with a reference to the governing labor statute. The host application stores both the result and the plan SHA for audit trail.

**Latency:** 2-4 ms loopback; microseconds on the JIT hot path.

---

### Pattern 2 - Cognitive Orchestrator Kernel (Qomni-style)

Use when building an AI system that should resolve deterministic queries deterministically and escalate only open-ended queries to other strategies.

```
                   +--------------------------+
  User / API  -->  |   Orchestrator (Qomni)   |
                   |  ----------------------  |
                   |  Intent classifier       |
                   |  Reflex cache            |
                   |  Memory (HDC, facts)     |
                   |  Expert mixture          |
                   |  Adversarial veto        |
                   +------------+-------------+
                                | dispatch
        +-----------------------+----------------------+
        v                       v                      v
   +---------+            +-----------+          +------------+
   |  QOMN   |            | Retrieval |          | Veto and   |
   |  kernel |            |   layer   |          | rejection  |
   +---------+            +-----------+          +------------+
  (this paper)
```

**Example:** a user asks "size a fire pump for 5000 ft ordinary hazard." The orchestrator classifies the intent, extracts parameters, dispatches to QOMN `plan_pump_sizing`, returns the exact result with citation. Queries not classifiable deterministically are rejected rather than hallucinated.

**Relevance:** the companion system (Qomni Cognitive OS) is being built around this pattern.

---

### Pattern 3 - Edge Compute and Offline Deployment

Use when computation must happen on a device with no network or constrained resources (remote construction sites, clinical bedside, industrial control cabinets).

```
+----------------------------+
|     Device (offline)       |
|  ------------------------  |
|  Local QOMN binary         |
|  (WASM or native AArch64)  |
|  Plan stdlib bundled       |
|  No network, no cloud,     |
|  no LLM, no API keys       |
|                            |
|  Input -> local compute -> |
|  output (bit-identical on  |
|  same hardware every time) |
+------------+---------------+
             ^ sync when online
             |
+------------+---------------+
|  Central registry (opt.)   |
|  for plan updates + logs   |
+----------------------------+
```

**Example:** a tablet at a remote construction site runs hydraulic calculations for a fire-protection design review without cellular coverage. When the device returns to network, audit logs sync to a central registry.

---

### Pattern 4 - Regulatory / Certification Pipeline

Use when a regulator or certification body needs an independent way to reproduce a calculation submitted in a design package.

```
       Design submission (PDF + numbers)
                     |
                     v
      +----------------------------+
      |  Reviewer pipeline         |
      |  ------------------------  |
      |  1. Extract parameters     |
      |  2. Call QOMN with same    |
      |     inputs                 |
      |  3. Compare bit-exact      |
      |     output to submission   |
      |  4. Flag discrepancies     |
      +--------------+-------------+
                     |
                     v
           Approve / Return / Flag
```

**Example:** an AHJ reviewing a fire-protection design package automatically verifies that every number in the package reproduces from the cited parameters. A discrepancy means either a transcription error or a genuine disagreement with the standard; the reviewer has machine-generated evidence, not subjective judgment.

---

### Pattern 5 - Scientific Reproducibility Infrastructure

Use when a research lab needs its numerical reductions to survive across team members, time, and hardware.

```
+-----------------------------+
|  Lab codebase (Git repo)    |
|  -------------------------  |
|  .qomn plans for reductions |
|    - uncertainty propagation|
|    - fit of known functions |
|    - calibration pipelines  |
|  versioned alongside data   |
+-------------+---------------+
              | on every analysis run
              v
+-----------------------------+
|  QOMN produces bit-exact    |
|  output; hash recorded in   |
|  lab notebook               |
+-----------------------------+

Publication cites plan SHA + QOMN version.
Anyone can reproduce the analysis later.
```

**Example:** a lab calibrates an instrument with a known functional form. The fitting procedure is a QOMN plan; the plan SHA is cited in every paper. Five years later, a graduate student re-runs the plan with archived raw data and obtains bit-identical results.

---

## Proposed Architectures by Industry

The five patterns above are generic. This section sketches how they apply concretely to several industries, with specific plan names and integration notes.

### A. Engineering and Construction (fire, structural, electrical, hydraulic)

**Plans already in the library (sample):** `plan_pump_sizing`, `plan_sprinkler_system`, `plan_full_fire_system`, `plan_beam_analysis`, `plan_column_design`, `plan_footing`, `plan_electrical_load`, `plan_voltage_drop`, `plan_pipe_hazen`, `plan_pipe_manning`.

```
+----------------------------+
|  Design CAD (AutoCAD,      |
|  Revit, proprietary tools) |
+-------------+--------------+
              | extract params
              v
+----------------------------+
|  QOMN REST API             |
|  executes plan             |
+-------------+--------------+
              | bit-exact result + citation
              v
+----------------------------+
|  Design document           |
|  (PDF or digital twin)     |
|  embeds plan SHA in every  |
|  calculated field          |
+----------------------------+
```

**Integration steps:** (1) build a CAD plugin that calls QOMN via HTTP; (2) the plugin replaces the CAD tool internal calculator; (3) every calculated field in the design stores the plan SHA so AHJ review can re-run it.

---

### B. Clinical Dosing and Pharmacology

**Plans to develop:** `plan_warfarin_dose(weight, inr, age)`, `plan_vancomycin_dose(weight, crcl)`, `plan_pediatric_fluid(weight_kg, burn_tbsa_pct)`, `plan_parenteral_nutrition(...)`.

```
+---------------------------+
| Hospital EHR (Epic,       |
| Cerner, HIS propio)       |
+-------------+-------------+
              | patient data
              v
+---------------------------+
| Prescribing module        |
| calls QOMN with patient   |
| params                    |
+-------------+-------------+
              | bit-exact dose + protocol ref
              v
+---------------------------+
| Prescription recorded     |
| with plan SHA +           |
| institutional protocol ID |
+---------------------------+
```

**Integration steps:** (1) clinical pharmacology team writes plans against institutional protocols; (2) each plan cites the protocol version; (3) EHR calls QOMN before writing prescription; (4) audit trail binds every dose to protocol version, making pharmacovigilance trivial.

**Critical safety property:** same patient state always produces the same dose. Deviations are detectable as either a changed protocol version or a changed patient state.

---

### C. Legal and Fiscal (tax, payroll, compliance)

**Plans already present:** `plan_factura_peru`, `plan_planilla`, `plan_liquidacion_laboral`, `plan_multa_sunafil`.

**Plans to develop:** `plan_iva_calculation(country, amount)`, `plan_withholding_tax(...)`, `plan_property_tax(jurisdiction, ...)`, `plan_transfer_pricing(...)`.

```
+-----------------------------+
|  ERP financial module       |
|  (SAP, Odoo, custom)        |
+-------------+---------------+
              | transaction data
              v
+-----------------------------+
|  QOMN tax / payroll plan    |
|  cites the exact tax law    |
|  article or payroll statute |
+-------------+---------------+
              | tax / deduction / obligation + citation
              v
+-----------------------------+
|  Invoice / payslip / return |
|  stores plan SHA + statute  |
|  version for audit          |
+-----------------------------+
```

**Integration steps:** (1) local tax attorneys author plans against national law; (2) on every law change, the plan version bumps, old version stays in repo; (3) any transaction recomputes with the law version valid at its date; (4) tax authority audits are straightforward: given transaction date, run the plan SHA valid then.

---

### D. Financial Engineering and Actuarial

**Plans to develop:** `plan_loan_amortization`, `plan_black_scholes_option`, `plan_duration_bond`, `plan_net_present_value`, `plan_solvency_reserve`, `plan_capital_adequacy`.

```
+----------------------------+
| Trading / risk desk app    |
+-------------+--------------+
              | positions + market data
              v
+----------------------------+
| QOMN valuation plan        |
| closed-form: bonds,        |
| vanilla options, PV/FV,    |
| actuarial reserves         |
+-------------+--------------+
              | value + model citation
              v
+----------------------------+
| Risk report / regulatory   |
| filing with plan SHA       |
+----------------------------+
```

**Note:** QOMN is for **closed-form** financial math (deterministic by construction). Monte Carlo, stochastic calibration, and ML prediction are **outside its domain** - those belong to a stochastic tier.

---

### E. HVAC, Energy and Building Performance

**Plans already present:** `plan_hvac_cooling`, `plan_hvac_ventilation`, `plan_solar_fv`.

```
+---------------------------+
| Building design software  |
| (Revit MEP, IES, IDA-ICE) |
+-------------+-------------+
              | building envelope + climate data
              v
+---------------------------+
| QOMN HVAC plan            |
| sizes AHU, chiller,       |
| ventilation per ASHRAE    |
+-------------+-------------+
              | design load + ASHRAE clause
              v
+---------------------------+
| LEED / energy certif.     |
| submittal with plan SHAs  |
+---------------------------+
```

---

### F. Occupational Safety and Industrial Hygiene

**Plans to develop:** `plan_osha_exposure_limit`, `plan_arc_flash_energy`, `plan_noise_dose(lep_d)`, `plan_confined_space_ventilation`.

```
+----------------------------+
| Site HSE management system |
+-------------+--------------+
              | sensor / measurement data
              v
+----------------------------+
| QOMN exposure plan         |
| evaluates against OSHA /   |
| national limits            |
+-------------+--------------+
              | pass / fail + citation
              v
+----------------------------+
| HSE record with plan SHA   |
| and timestamped evidence   |
+----------------------------+
```

---

### G. Agriculture and Irrigation

**Plans to develop:** `plan_fao56_et(crop, climate)`, `plan_drip_irrigation(...)`, `plan_fertilizer_balance(...)`.

```
+------------------------+
|  Farm management app   |
|  (weather + soil data) |
+-----------+------------+
            | daily parameters
            v
+------------------------+
|  QOMN agro plan        |
|  FAO-56, soil-water    |
|  balance, nutrient need|
+-----------+------------+
            | recommendation
            v
+------------------------+
|  Irrigation controller |
|  / field report        |
+------------------------+
```

**Integration note:** this pattern is particularly compelling at the **edge** (Pattern 3). A solar-powered field controller with offline QOMN can compute irrigation needs without any cloud dependency.

---

### H. Manufacturing and Process Control

**Plans to develop:** `plan_pid_tuning(process, target)`, `plan_thermodynamic_cycle`, `plan_material_yield_fatigue`, `plan_chemical_stoichiometry`.

```
+-------------------------+
|  MES / SCADA            |
+-----------+-------------+
            | process setpoints
            v
+-------------------------+
|  QOMN on-premise        |
|  (Pattern 3 - edge)     |
|  computes setpoint      |
+-----------+-------------+
            | deterministic control signal
            v
+-------------------------+
|  PLC / actuator         |
+-------------------------+
```

**Integration note:** safety-critical control loops can use QOMN as the **formal-verification stage**: whenever a proposed PLC setpoint is computed, QOMN recomputes it independently and compares. Discrepancies trigger a safe-state fallback.

---

### Cross-industry properties

Every integration above shares three properties that emerge from QOMN's design:

1. **Same runtime, different plans.** No per-industry language variants. The Cranelift JIT, type system, and verification apparatus are shared across clinical, legal, financial, engineering, agricultural, and industrial deployments.

2. **Stateless HTTP contract.** Integration requires only speaking JSON over HTTP. No SDK, no vendor lock-in, no custom binary protocol.

3. **Citation-bearing results.** Whatever the domain, every QOMN response carries a reference to the governing document (standard, statute, protocol). This is the property that makes QOMN useful for regulated work.

### What QOMN is not suited for (repeated for clarity)

Across all these industries, QOMN is a poor fit for:
- Open-ended natural language (use an LLM).
- Stochastic ML inference (use PyTorch/TF stacks).
- Complex constraint optimization where the model itself is uncertain (use solvers like Gurobi, Z3).
- Real-time control loops with sub-millisecond latency that cannot afford HTTP overhead (embed the QOMN Rust library directly or use the WebAssembly build).

Choosing the right tool for each sub-problem is the whole point of the thinking / executing separation described in this paper.

## Use Cases and Benefits

| Domain | Standard | Beneficiaries |
|---|---|---|
| Fire protection | NFPA 13 / 20 / 72 / 101 | Fire engineers, AHJ reviewers, insurers |
| Structural | AISC 360, ACI 318, ASCE 7 | Structural engineers, plan reviewers |
| Electrical | NEC, IEC 60364, IEEE 141 | Electrical engineers, utilities |
| Hydraulics | Hazen-Williams, Manning | Civil engineers, water authorities |
| HVAC | ASHRAE 62.1, 90.1 | Mechanical engineers, LEED certifiers |
| Financial | NIIF, SUNAT, DL 728 (Peru) | Accountants, auditors |
| Clinical dosing (future) | Pharmacology protocols | Hospitals, pharmacy informatics |
| Legal/fiscal (future) | National codes | Compliance, payroll |

**For engineers:** plain-text plans under Git instead of black-box spreadsheets. Your signed drawing can point to the plan SHA.
**For AI developers:** route engineering queries to QOMN (deterministic, free, microsecond-latency) instead of LLM APIs.
**For researchers:** reference implementation of the deterministic-compute branch of hybrid neuro-symbolic architectures.
**For regulators:** working example of certifiable AI computation, reproducible without vendor cooperation.

---

## Projection — Where QOMN Is Going

**Near-term (6 months):** scale library from 57 to hundreds of plans, ARM64 bit-exact determinism, WebAssembly edge deployments, community contribution pipeline.

**Medium-term (6–18 months):** formal verification (Lean / Coq / F*), public release of Qomni Cognitive OS (LLM-free orchestrator), standards body engagement (IEEE, ISO), peer-reviewed publication.

**Long-term:** cross-industry open standard for certifiable computation, trust substrate for safety-critical AI, shared infrastructure contributed by domain experts and reviewed by standards bodies.

---

## Current Maturity (honest calibration)

**What QOMN already is:** a working deterministic execution layer in production, architecturally sound foundation, permissively licensed, reproducible end-to-end.

**What QOMN is not yet:** a fully distributed multi-tenant system validated under heavy load, a complete cognitive architecture comparable to AGI programs, a peer-reviewed standard with institutional backing.

The difference between today and the full vision is **scope and maturity, not direction**.

---


---

## Qomni Cognitive OS — The Bigger Picture

QOMN is one half of a larger architecture. The other half is **Qomni Cognitive OS**, a cognitive orchestration layer currently under active development. This section describes that broader system so readers understand where QOMN fits.

### What is Qomni Cognitive OS?

Qomni is a **cognitive operating system** that orchestrates memory, specialized engines, and decision logic — **without any dependence on large language models**. It routes incoming queries through a cascade of increasingly specialized strategies and stops at the first strategy that can answer with enough confidence.

Its design philosophy is the inverse of the LLM-default pattern: instead of sending everything to a neural model and falling back to deterministic tools when needed, Qomni sends everything to deterministic tools first and explicitly rejects what it cannot resolve. Queries the system cannot answer deterministically are acknowledged as such rather than hallucinated.

### Architecture at a glance

```
                       ┌─────────────────────────┐
  User query  ──────►  │    Qomni (thinks)       │
                       │  ─────────────────────  │
                       │  - Intent router        │
                       │  - Reflex cache         │
                       │  - HDC memory (2048-bit)│
                       │  - Expert mixture       │
                       │  - Adversarial veto     │
                       │  - Permanent memory     │
                       └──────────┬──────────────┘
                                  │ dispatch
                                  ▼
                       ┌─────────────────────────┐
                       │   QOMN (executes)       │ ◄── this paper
                       │  ─────────────────────  │
                       │  - DSL parser           │
                       │  - Cranelift JIT        │
                       │  - AVX2 sweep kernel    │
                       │  - 57 plans / 10 domains│
                       │    (unbounded — any   │
                       │     closed-form domain)│
                       │  - Bit-exact results    │
                       └─────────────────────────┘
```

**Qomni decides what to compute. QOMN computes it.** The two communicate through the same public HTTP API that any external client uses. No special coupling is required, and QOMN does not depend on Qomni to function — a deliberate architectural choice to keep each layer independently meaningful.

### Qomni's six strategies (all LLM-free)

1. **Reflex cache** — zero-compute pattern match on previously seen queries.
2. **Deterministic compute tier backed by QOMN** — for engineering calculations, dispatches to QOMN and returns bit-exact results.
3. **Hyperdimensional memory** — 2,048-bit binary hypervectors for semantic similarity without neural embeddings.
4. **Mixture of expert retrievers** — specialized indexes over curated knowledge slices, combined by consensus voting.
5. **Adversarial veto layer** — compares candidate responses against a fact database; blocks responses containing detected contradictions.
6. **Permanent memory tier** — persists facts across sessions in a deterministic indexed store.

Notably absent: any neural-generation tier. Queries that none of the six strategies can resolve are **rejected explicitly**, not forwarded to an LLM fallback.

### Why this separation matters

The separation between Qomni (decides) and QOMN (computes) is the core architectural bet of the project:

- **Qomni can evolve** its decision logic, memory strategies, and orchestration without touching the compute layer.
- **QOMN can be used standalone** by anyone building their own cognitive system with different orchestration philosophies.
- **Both layers are verifiable independently** — QOMN via the public API described in this paper; Qomni via the separate paper and artifact planned for its public release.
- **The contract is stable and minimal** — JSON over HTTP, no binary protocol, no proprietary handshake, no neural-specific assumptions.

Any team can replace either layer without breaking the other. This is unusual for cognitive architectures, which typically ship as monoliths.

### Current status

**QOMN is the foundation, and it is already operational.** The deterministic execution layer described in this paper is in production today at `desarrollador.xyz`, with all 57 initial plans live and verifiable via curl. The architecture is not hypothetical: it compiles, runs, passes tests, and responds to public traffic. **The 57-plan figure is a lower bound, not a limit** — adding new plans is a pure contribution process, no core changes required. This is the solid, unbounded ground on which Qomni is being built.

**Qomni Cognitive OS is under active development** on top of that foundation. Its core modules (intent router, reflex cache, hyperdimensional memory, expert mixture, adversarial veto, permanent memory) are being designed and validated internally against real workloads. The system is **not yet open-sourced**, but the work is advancing continuously. A separate paper and artifact will be released when Qomni is ready for independent evaluation.

The sequence is deliberate: **first publish and stabilize the execution kernel (QOMN, this paper), then publish the orchestration layer (Qomni, next paper)**. This order lets reviewers and adopters validate each layer independently without waiting for the full system. No part of this QOMN paper depends on Qomni being public; every claim here is reproducible with QOMN alone.

We mention Qomni here because readers encountering both names in the author's work deserve a clear picture of the relationship. **This paper is about QOMN. Qomni is the larger system already being built on top of it.**

### Compact summary (both systems in one table)

| Aspect | QOMN (this paper) | Qomni Cognitive OS (future paper) |
|---|---|---|
| Kind | Language + JIT runtime | Cognitive orchestrator |
| Role | Executes | Decides |
| Operation | Deterministic computation | Strategy selection + memory |
| Mode | Stateless per call | Stateful, persistent |
| Focus | Mathematical exactness | Contextual judgment |
| LLM dependency | None | None |
| Public artifact | Yes, this repo | Not yet (in development) |
| License | Apache-2.0 | TBD (planned permissive) |

## Installation Guide

### Option A — Public API (zero install)

```bash
curl -X POST https://desarrollador.xyz/api/plan/execute \
  -H 'Content-Type: application/json' \
  -d '{"plan":"plan_pump_sizing","params":{"Q_gpm":500,"P_psi":100,"eff":0.75}}'
```

Returns `hp_required: 16.835017` — bit-exact every time.

### Option B — Local installation (~10 min)

```bash
git clone https://github.com/condesi/qomn-paper
cd qomn-paper
bash scripts/install.sh
QOMN_API_BASE=http://127.0.0.1:9001 bash scripts/reproduce.sh
```

Requires Linux or macOS, git, curl, C compiler. Rust installs automatically via rustup.

### Environment variables

| Variable | Default | Effect |
|---|---|---|
| `QOMN_API_BASE` | `https://desarrollador.xyz` | Base URL for reproducibility script |
| `QOMN_SERVER_URL` | `https://desarrollador.xyz` | Base URL for REPL client |
| `QOMN_NO_FMA` | unset | Disable FMA for cross-arch bit-exact reproduction |

### Verify

```bash
curl http://127.0.0.1:9001/api/health
# expect: "lang":"QOMN","version":"3.2","jit":true
```

## Citation

```bibtex
@article{rojasmasgo2026qomn,
  title   = {QOMN: A Domain-Specific Language for Deterministic Engineering
             Calculations at Nanosecond-Scale Latency},
  author  = {Rojas Masgo, Percy and {Qomni AI Lab}},
  year    = {2026},
  month   = {April},
  note    = {Open Standard, MIT License. QOMN v3.2 benchmark on AMD EPYC (2026-04-19): 5.37–10.69 ns JIT hot path; 396M scenarios/sec simulation engine at 53.2% SIMD utilization; initial 57-plan library across 10 engineering domains (architecturally unbounded — scales to any closed-form, citation-bearing domain)},
  url     = {https://github.com/condesi/qomn-lang}
}
```

---

*Built by Percy Rojas Masgo · CEO Condesi Perú · Qomni AI Lab*
*Live at [desarrollador.xyz/benchmark.html](https://desarrollador.xyz/benchmark.html)*
