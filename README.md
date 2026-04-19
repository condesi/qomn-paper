# QOMN Paper — Open Preprint Artifact

**An Open-Source Domain-Specific Language and JIT Runtime for Deterministic Engineering Computation**

**Author:** Percy Rojas Masgo — Condesi Perú / Qomni AI Lab
**Contact:** percy.rojas@condesi.pe
**Version:** Preprint v1.0 — April 2026
**License:** Paper text under MIT · QOMN runtime under Apache-2.0

---

## What is this repository?

This is the public artifact for the QOMN preprint: LaTeX source of the paper, bibliography, reproducibility scripts, and local installation instructions for the runtime. Every numerical claim in the paper is reproducible against either the public API at `https://desarrollador.xyz/` or a local installation produced by the install script.

## What is QOMN?

QOMN is a domain-specific language and JIT runtime for deterministic engineering computation. In one sentence: it compiles closed-form engineering formulas (NFPA fire protection, IEC electrical, AISC structural, Hazen-Williams hydraulics, payroll, and others) directly to native x86-64 machine code via the Cranelift backend, producing bit-exact results for identical inputs.

In one paragraph: engineering, clinical, and regulatory domains require reproducibility that stochastic AI systems cannot provide. QOMN fills that gap with a small, focused, open-source DSL whose plans carry citations to their governing standards in source. The runtime is production-hardened (adversarial test corpus, NaN shield, tiered JIT), verifiable (public HTTP API), and permissively licensed (Apache-2.0).

QOMN is not a replacement for large language models or a competitor in their space. It is an execution layer for problems where deterministic correctness is the primary requirement, designed to compose cleanly with reasoning layers that excel at different tasks.

## Repository layout

```
qomn-paper/
├── README.md                 # this file
├── paper/
│   ├── main.tex              # full paper (~820 lines LaTeX, ~15 pages compiled)
│   └── main.bib              # bibliography (17 references)
├── scripts/
│   ├── reproduce.sh          # verify paper claims against the live API
│   └── install.sh            # install QOMN runtime locally (Linux/macOS)
└── figures/                  # (reserved for future diagrams)
```

## How to reproduce the paper's measurements

### Option A — against the public API (30 seconds, no local install)

```bash
git clone https://github.com/condesi/qomn-paper
cd qomn-paper
bash scripts/reproduce.sh
```

The script queries `https://desarrollador.xyz/` and checks:
- API reachability
- QOMN version and JIT activation
- Determinism (5 identical invocations → 5 identical bits)
- SIMD utilization
- Adversarial input handling
- Plan catalog size

### Option B — against a local installation (5–15 minutes, full control)

```bash
git clone https://github.com/condesi/qomn-paper
cd qomn-paper
bash scripts/install.sh                  # builds QOMN from source
# After install prints "server ready":
QOMN_API_BASE=http://127.0.0.1:9001 bash scripts/reproduce.sh
```

This builds QOMN from the public source repository (`github.com/condesi/qomn`), starts it on localhost, and runs the same verification against your local instance. This removes any dependency on the author's infrastructure.

## How to compile the paper to PDF

```bash
cd paper
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex     # run twice for cross-references to resolve
```

Produces `main.pdf`. Compile-time dependencies: a standard TeX Live distribution (\texttt{texlive-latex-recommended} + \texttt{texlive-fonts-recommended} on Debian/Ubuntu).

## Summary of what the paper contains

- **Introduction** and motivation for deterministic computation in regulated domains
- **Language design**: EBNF grammar, surface syntax, compilation pipeline (parser → typeck → HIR → bytecode IR → Cranelift / LLVM / WASM)
- **Runtime architecture**: tiered JIT with 50-call warm-up, SoA AVX2 scenario sweep, NaN-Shield, OracleCache
- **Determinism policy**: explicit rules for FMA, rounding, denormals, signed-zero canonicalization
- **Physical unit type system** with NFPA/IEC range validation
- **Standard library**: the 57 plans across 10 engineering domains with full domain table
- **Measurements**: determinism demonstration (5 bit-exact runs), SIMD utilization, scenario throughput, all reproducible via `scripts/reproduce.sh`
- **Novelty section**: decomposition of which combination of properties is new, with explicit precedents cited (Catala, Julia, Modelica, etc.)
- **Benefits section**: concrete value offered to AI researchers, industry developers, practicing engineers, regulators, standards bodies, and CS researchers
- **Scope note on Qomni Cognitive OS**: brief description of the author's complementary LLM-free orchestration system under active development
- **Beyond engineering**: the generalization of QOMN's contract to clinical, legal, financial, and scientific domains
- **Limitations and threats to validity**: stated explicitly
- **Future work and call for contributions**: open invitation for community involvement

## Citation

```bibtex
@misc{rojas2026qomn,
  author       = {Percy Rojas Masgo},
  title        = {QOMN: An Open-Source Domain-Specific Language and JIT Runtime
                  for Deterministic Engineering Computation},
  year         = {2026},
  month        = {April},
  note         = {Preprint. Qomni AI Lab, Condesi Perú.},
  url          = {https://github.com/condesi/qomn-paper}
}
```

## Associated resources

- **QOMN runtime source** (Apache-2.0): [`github.com/condesi/qomn`](https://github.com/condesi/qomn)
- **QOMN language specification** (MIT): [`github.com/condesi/crysl-lang`](https://github.com/condesi/crysl-lang)
- **Live API**: [`desarrollador.xyz`](https://desarrollador.xyz/)
- **Live benchmark dashboard**: [`desarrollador.xyz/benchmark.html`](https://desarrollador.xyz/benchmark.html)

## Contributing

Pull requests are welcome in two categories:

1. **Corrections to the paper** (factual, typographical, bibliographic) via pull request against this repository.
2. **New engineering plans** (with citations to governing standards) via pull request against the runtime repository at [`github.com/condesi/qomn`](https://github.com/condesi/qomn).

Please ensure any new plan includes a citation in source, a regression test, and an adversarial test if the plan admits input ranges.

## License

- The text of the paper (files under `paper/`) is licensed under the **MIT License**, matching the spirit of open academic dissemination.
- The QOMN runtime referenced by the paper is licensed under **Apache-2.0**.
- The scripts in `scripts/` are MIT.

See `LICENSE` for the full text when present; in its absence, the SPDX identifiers above govern.

## Contact

Percy Rojas Masgo
Condesi Perú — Qomni AI Lab
percy.rojas@condesi.pe
