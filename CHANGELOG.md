# Changelog

All notable changes to this preprint artifact will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project loosely adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
adapted for a paper artifact (major = substantive revision, minor = new section or
measurement, patch = typo/formatting).

## [Unreleased]

## [1.0-preprint] — 2026-04-19

### Added

- Initial public release of the QOMN preprint paper (`paper/main.tex`).
- Bibliography with 17 references (`paper/main.bib`).
- Reproducibility script (`scripts/reproduce.sh`) verifying 6 paper claims
  against the public API at `desarrollador.xyz`.
- Local installation script (`scripts/install.sh`) for Linux and macOS.
- Standard open-source project files: `LICENSE`, `CITATION.cff`,
  `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`.
- GitHub issue templates for paper corrections, reproduction reports, and questions.
- GitHub pull request template.
- GitHub Actions workflow (`.github/workflows/build-pdf.yml`) that compiles
  the paper to PDF and attaches it as a build artifact.
- Placeholder directories (`figures/`, `data/`) with README files explaining
  intended contents and contribution paths.

### Paper highlights

- ~22 pages, 869 LaTeX source lines, 13 main sections.
- Complete EBNF grammar of the QOMN language.
- Full end-to-end usage example (plan source → HTTP call → JSON response).
- Table of 20 runtime modules with measured lines-of-code.
- Table of 57 plans across 10 engineering domains.
- Dedicated sections on novelty, benefits per audience, scientific contribution,
  statement from the author, and scope note on the forthcoming Qomni Cognitive OS.
- Explicit limitations and threats to validity.

[Unreleased]: https://github.com/condesi/qomn-paper/compare/v1.0-preprint...HEAD
[1.0-preprint]: https://github.com/condesi/qomn-paper/releases/tag/v1.0-preprint
