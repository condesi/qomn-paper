---
name: Reproduction report
about: You ran scripts/reproduce.sh and want to share results (pass or fail)
title: '[repro] '
labels: reproduction
assignees: ''
---

## Result

- [ ] All checks passed
- [ ] Some checks failed (describe below)

## Environment

- **OS:**
- **Kernel:** (output of `uname -a`)
- **CPU model:** (from `/proc/cpuinfo` or `sysctl hw.model`)
- **RAM:**
- **Local or public API?** (local install / public `desarrollador.xyz`)
- **QOMN version:** (from `/api/health` response)

## Full output

```
<!-- paste stdout + stderr of `bash scripts/reproduce.sh` -->
```

## If any check failed

- **Expected value (from paper):**
- **Observed value:**
- **Any hypothesis for the discrepancy:**

## Permission to cite

- [ ] I give permission for the author(s) of the paper to cite this reproduction report by GitHub handle in a future revision or appendix.
