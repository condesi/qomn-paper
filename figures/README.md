# Figures

This directory contains figures and diagrams referenced in the paper.

The paper source (`paper/main.tex`) currently uses LaTeX-rendered diagrams inline (ASCII art for the cascade architecture, standard tabular figures for data). External figure files are reserved for future additions:

## Planned figures

1. **Architecture diagram** — QOMN compilation pipeline (parser → typeck → HIR → bytecode IR → Cranelift / LLVM / WASM)
2. **Scenario throughput** — measured scenarios/sec vs. theoretical AVX2 ceiling
3. **Latency distribution** — p50 / p95 / p99 per plan class
4. **Determinism proof** — SHA-256 hash stability across 20 runs
5. **Plan-as-citation diagram** — how a plan source file links to its standard

Contributions of figures (SVG preferred for scalability, PNG acceptable) are welcome via pull request. Please ensure all figures are either original work or have a compatible open license.

## Format guidelines

- **SVG** preferred for diagrams and charts.
- **PNG** at 300 DPI for raster images.
- Figure sources (Inkscape `.svg` files, Graphviz `.dot` files, Python plotting scripts) should be included in source form alongside the rendered figure so others can regenerate or modify them.
