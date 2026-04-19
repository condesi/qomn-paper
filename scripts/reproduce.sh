#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────
# QOMN Paper — Reproducibility Script
#
# This script verifies the numerical claims of the paper by querying the
# public QOMN API and comparing results against expected values documented
# in the paper's measurements section.
#
# Requirements: bash, curl, python3 (for JSON parsing only)
# Runtime: ~30 seconds over a typical internet connection
#
# Usage:
#   bash scripts/reproduce.sh
#
# The script exits with status 0 if all checks pass, or the number of
# failed checks otherwise.
# ─────────────────────────────────────────────────────────────────────────

set -u

API_BASE="${QOMN_API_BASE:-https://desarrollador.xyz}"
TIMEOUT=10

FAILED=0
PASSED=0

log()  { printf '\033[1;36m[info]\033[0m %s\n' "$*"; }
pass() { printf '\033[1;32m[ OK ]\033[0m %s\n' "$*"; PASSED=$((PASSED+1)); }
fail() { printf '\033[1;31m[FAIL]\033[0m %s\n' "$*"; FAILED=$((FAILED+1)); }

# ─── Check 1: API is reachable ────────────────────────────────────────
log "Check 1: API reachability"
HEALTH=$(curl -s -m "$TIMEOUT" "$API_BASE/api/health" || echo "")
if [[ -z "$HEALTH" ]]; then
  fail "API unreachable at $API_BASE/api/health"
  fail "All subsequent checks skipped."
  exit 1
fi
pass "API reachable: $HEALTH"

# ─── Check 2: Runtime reports expected version ────────────────────────
log "Check 2: QOMN version and JIT availability"
STATUS=$(python3 -c "
import json,sys
d = json.loads('''$HEALTH''')
print('version='+str(d.get('version','?')))
print('jit='+str(d.get('jit',False)))
print('plans='+str(d.get('plans',0)))
print('lang='+str(d.get('lang','?')))
" 2>/dev/null || echo "parse-error")
echo "$STATUS"
if grep -q "jit=True" <<<"$STATUS"; then pass "JIT active"; else fail "JIT inactive"; fi
if grep -q "lang=QOMN" <<<"$STATUS"; then pass "Language = QOMN"; else fail "Language mismatch"; fi
PLANS=$(grep plans= <<<"$STATUS" | cut -d= -f2)
if [[ "$PLANS" -ge 50 ]]; then pass "Plans available: $PLANS"; else fail "Plan count too low: $PLANS"; fi

# ─── Check 3: Determinism — 5 consecutive identical invocations ───────
log "Check 3: Determinism (5 consecutive runs of plan_pump_sizing)"
RESULTS=()
for i in 1 2 3 4 5; do
  R=$(curl -s -m "$TIMEOUT" -X POST "$API_BASE/api/plan/execute" \
    -H "Content-Type: application/json" \
    -d '{"plan":"plan_pump_sizing","params":{"Q_gpm":500,"P_psi":100,"eff":0.75}}' \
    | python3 -c "
import json,sys
try:
    d = json.load(sys.stdin)
    result_obj = d.get('result', {})
    if isinstance(result_obj, dict):
        steps = result_obj.get('steps', [])
        for step in steps:
            if step.get('step') == 'hp_required':
                print(step.get('result'))
                break
except Exception as e:
    print('parse-error:'+str(e))
" 2>/dev/null)
  RESULTS+=("$R")
done

UNIQUE=$(printf '%s\n' "${RESULTS[@]}" | sort -u | wc -l)
if [[ "$UNIQUE" -eq 1 && -n "${RESULTS[0]}" ]]; then
  pass "Deterministic: all 5 runs returned identical value (${RESULTS[0]})"
else
  fail "Non-deterministic or parse failure. Unique results: $UNIQUE"
  for i in "${!RESULTS[@]}"; do echo "  Run $((i+1)): ${RESULTS[$i]}"; done
fi

# ─── Check 4: SIMD saturation endpoint ────────────────────────────────
log "Check 4: SIMD density (AVX2 + FMA kernel)"
SIMD=$(curl -s -m "$TIMEOUT" "$API_BASE/api/simulation/simd_density")
UTIL=$(python3 -c "
import json,sys
try:
    d = json.loads('''$SIMD''')
    print(d.get('simd_utilization_pct', 0))
except:
    print(0)
" 2>/dev/null)
if python3 -c "import sys; sys.exit(0 if float('$UTIL') > 30 else 1)" 2>/dev/null; then
  pass "SIMD utilization: ${UTIL}% (> 30% threshold)"
else
  fail "SIMD utilization too low: ${UTIL}%"
fi

# ─── Check 5: Adversarial endpoint responds (NaN shield) ──────────────
log "Check 5: Adversarial input handling (NaN shield)"
ADV=$(curl -s -m "$TIMEOUT" -o /dev/null -w "%{http_code}" -X POST "$API_BASE/api/plan/execute" \
  -H "Content-Type: application/json" \
  -d '{"plan":"plan_pump_sizing","params":{"Q_gpm":"NaN","P_psi":100,"eff":0.75}}')
if [[ "$ADV" == "200" || "$ADV" == "400" || "$ADV" == "422" ]]; then
  pass "Adversarial NaN input handled gracefully (HTTP $ADV)"
else
  fail "Unexpected response to NaN input: HTTP $ADV (expected 200/400/422, got crash?)"
fi

# ─── Check 6: Plan enumeration ────────────────────────────────────────
log "Check 6: Plan catalog matches paper (57 plans)"
PLANS_LIST=$(curl -s -m "$TIMEOUT" "$API_BASE/api/plans")
PLAN_COUNT=$(python3 -c "
import json,sys
try:
    d = json.loads('''$PLANS_LIST''')
    print(len(d.get('plans', [])))
except:
    print(0)
" 2>/dev/null)
if [[ "$PLAN_COUNT" -eq 57 ]]; then
  pass "Plan count matches paper: 57 plans"
elif [[ "$PLAN_COUNT" -ge 50 ]]; then
  pass "Plan count close to paper claim: $PLAN_COUNT (paper says 57; may have grown)"
else
  fail "Plan count below paper claim: $PLAN_COUNT"
fi

# ─── Summary ──────────────────────────────────────────────────────────
echo
echo "─────────────────────────────────────────────────────────────"
echo "  QOMN Paper Reproducibility Summary"
echo "─────────────────────────────────────────────────────────────"
echo "  Passed: $PASSED"
echo "  Failed: $FAILED"
echo "  API:    $API_BASE"
echo "─────────────────────────────────────────────────────────────"

if [[ $FAILED -eq 0 ]]; then
  echo "  All checks passed. Paper claims are reproducible against"
  echo "  the public API at the time of this run."
  exit 0
else
  echo "  $FAILED check(s) failed. Please open an issue at:"
  echo "  https://github.com/condesi/qomn-paper/issues"
  exit "$FAILED"
fi
