# Contributing to QOMN Paper

Thank you for considering a contribution. This repository hosts the public artifact of the QOMN preprint: LaTeX source, bibliography, reproducibility scripts, and related materials. The runtime itself lives in a separate repository ([`condesi/qomn`](https://github.com/condesi/qomn)).

Please read this document before opening an issue or pull request.

## What kinds of contributions are welcome?

### 1. Corrections to the paper text

- Typos, grammar, unclear sentences
- Incorrect citations or missing references
- Factual errors in technical descriptions
- Improvements to tables and figures

Please open a pull request against `paper/main.tex` or `paper/main.bib`. For substantive changes, open an issue first to discuss.

### 2. Improvements to reproducibility

- Additional reproducibility checks in `scripts/reproduce.sh`
- Improvements to the install script for different operating systems
- Compatibility reports (e.g. "script works on Fedora 40 / fails on Alpine")

### 3. Reproduction reports

If you ran `scripts/reproduce.sh` and your results differ from what the paper claims, please open an issue with:
- Your OS and version
- The exact output of the script
- The expected values (from the paper) and what you observed
- Your network environment if relevant (some checks query the public API)

### 4. New engineering plans

Plans themselves should be contributed to the runtime repository: [`condesi/qomn`](https://github.com/condesi/qomn). Please do not add new plans to this paper repository; it is meant to remain a stable artifact matching the published preprint.

## What is out of scope for this repository?

- The runtime implementation itself → [`condesi/qomn`](https://github.com/condesi/qomn)
- The Qomni Cognitive OS (referenced in the paper) is not yet open-sourced
- Feature requests for the runtime → open them in the runtime repo

## How to open a good pull request

1. **Fork the repository** and create a branch from `main`.
2. **Make your change** in a focused commit. If changing the paper, please keep commits atomic (one idea per commit).
3. **Verify the paper still compiles** (locally via `pdflatex` or by triggering the GitHub Actions workflow).
4. **Run the reproducibility script** if your change touches any claimed number or endpoint.
5. **Submit the pull request** with a clear description of what changed and why.
6. **Sign your commits** with a real name and email. The canonical mailmap (`.mailmap` in the runtime repo) will ensure your attribution is displayed consistently.

## How to open a good issue

- **One issue per topic.** If you have three observations, open three issues.
- **Include line numbers** when reporting a paper error (e.g. "line 234 of `paper/main.tex`").
- **Include reproduction details** when reporting a numerical discrepancy.
- **Be precise in wording** — "the latency claim is off" is less useful than "Table 3, row 2: I measured 9.1 ms, the paper says 2-4 ms; my hardware is listed below."

## Code of conduct

Please be respectful, precise, and focused on the technical content. Discussions on license choice, politics, or off-topic matters will be closed. This is a working repository for an academic and engineering artifact, and we ask contributors to keep discussions on that footing.

## Security

If you discover a security issue in the reproducibility or install scripts (path traversal, command injection, credential leakage, etc.), please email the author directly at `percy.rojas@condesi.pe` rather than opening a public issue. We will credit you in the next version.

## Questions

For any question the above does not cover, please email:
- **Percy Rojas Masgo** — `percy.rojas@condesi.pe`

Thank you for helping improve this work.
