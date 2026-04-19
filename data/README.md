# Data

This directory is reserved for benchmark datasets and measurement dumps referenced in the paper.

## Planned contents

- **`benchmarks/`** — JSON dumps from `scripts/reproduce.sh` across different hardware platforms, submitted by the community as reproduction reports.
- **`determinism_hashes/`** — SHA-256 hashes of 10,000-scenario sweep outputs for each of the 57 plans, at different QOMN versions. Used as regression anchors.
- **`adversarial_corpus/`** — the corpus of 12,800,000 adversarial inputs used in the NaN-Shield stress tests (exported as compressed JSONL).

## How to contribute reproduction data

If you run `scripts/reproduce.sh` on your hardware and the output differs from the paper's claims, please:

1. Capture the full output (stdout + stderr).
2. Capture your environment (`uname -a`, `/proc/cpuinfo` model name, RAM, OS version).
3. Open an issue with both attached, or a pull request adding a file to this directory under `community_reports/YYYY-MM-DD-hostname.json`.

Community reports will be incorporated into the paper's reproducibility appendix in a future revision.

## Versioning

Files in this directory are versioned against specific QOMN releases. A file generated against QOMN v3.2 may not match output from QOMN v3.3 if the stdlib has been updated. Please include the version string (`QOMN-Version` header from `/api/health`) in every file you contribute.
