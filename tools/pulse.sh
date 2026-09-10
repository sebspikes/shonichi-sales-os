#!/usr/bin/env bash
# Fire the outbound Property Pulse workflow for one Airbnb listing.
# Usage: tools/pulse.sh <airbnb url or listing id> [lead_record_id] [founder] [listing_count] [company]
# Environment (never committed): PULSE_WEBHOOK_URL (required), PULSE_FOUNDER (seb|sotirios, default seb),
#   PULSE_FOUNDER_EMAIL (required for sotirios; defaults to Seb's address for seb).
# Exit codes: 0 fired, 1 webhook returned a non-200, 2 bad input or missing environment, 3 advisory daily cap hit,
#   anything else is curl's own transport error (6 DNS, 7 refused, 28 timeout).
# The workflow writes the Pulses row about 2 to 4 minutes later. Poll Airtable, not this script. See tools/pulse.md.
set -euo pipefail
in="${1:-}"; lead="${2:-}"; founder="${3:-${PULSE_FOUNDER:-seb}}"; count="${4:-}"; company="${5:-}"
[ -n "$in" ] || { echo "usage: tools/pulse.sh <airbnb url or listing id> [lead_id] [founder] [listing_count] [company]" >&2; exit 2; }
[ -n "${PULSE_WEBHOOK_URL:-}" ] || { echo "PULSE_WEBHOOK_URL is not set. Add it to the Claude Code environment variables (see tools/pulse.md)." >&2; exit 2; }
command -v python3 >/dev/null || { echo "python3 is required to build the payload." >&2; exit 2; }
founder=$(printf '%s' "$founder" | tr '[:upper:]' '[:lower:]')
case "$founder" in seb|sotirios) ;; *) echo "founder must be seb or sotirios, got: $founder" >&2; exit 2;; esac
if [ "$founder" = "sotirios" ]; then
  email="${PULSE_FOUNDER_EMAIL:-}"
  [ -n "$email" ] || { echo "PULSE_FOUNDER_EMAIL is not set. Sotirios's pulse email would otherwise go to Seb. Set it and retry." >&2; exit 2; }
else
  email="${PULSE_FOUNDER_EMAIL:-sebastian.spikes@higgihaus.com}"
fi
if [ -n "$count" ] && ! printf '%s' "$count" | grep -qE '^[0-9]+$'; then echo "listing_count must be a whole number, got: $count" >&2; exit 2; fi
id=$(printf '%s' "$in" | grep -oE '/(rooms/(plus/)?|luxury/listing/|hosting/listings/)[0-9]+' | grep -oE '[0-9]+$' | head -1 || true)
[ -n "$id" ] || id=$(printf '%s' "$in" | grep -oE '^[0-9]{8,}$' || true)
[ -n "$id" ] || { echo "Could not find an Airbnb listing ID in: $in (paste the /rooms/<id> link, short share links do not carry the ID)" >&2; exit 2; }
url="https://www.airbnb.co.uk/rooms/${id}"
# Advisory cap: 10 fires per founder per day, counted per machine and per session only. The real guard is the
# Pulses count Claude checks in Airtable before firing (tools/pulse.md).
stamp="${TMPDIR:-/tmp}/pulse-fires-${founder}-$(date -u +%Y%m%d)"
n=$(cat "$stamp" 2>/dev/null | tr -dc '0-9' || true); n="${n:-0}"
[ "$n" -lt 10 ] || { echo "Advisory daily cap reached: $n pulses fired by $founder from this machine today. Raise it in tools/pulse.sh if deliberate." >&2; exit 3; }
payload=$(python3 - "$url" "$lead" "$founder" "$email" "$count" "$company" <<'PY'
import json, sys
url, lead, founder, email, count, company = sys.argv[1:7]
body = {"listing_url": url, "lead_id": lead, "founder": founder, "founder_email": email,
        "pms": "Hostaway", "company": company, "source": "outbound"}
if count: body["listing_count"] = int(count)
print(json.dumps(body))
PY
)
resp=$(mktemp); trap 'rm -f "$resp"' EXIT
code=$(curl -sS -o "$resp" -w '%{http_code}' -m 30 -H 'content-type: application/json' -X POST "$PULSE_WEBHOOK_URL" --data "$payload") || { echo "Could not reach the webhook (curl exit $?)." >&2; exit 7; }
if [ "$code" = "200" ]; then
  echo $((n+1)) > "$stamp"
  echo "Fired. Listing $id, lead ${lead:-none}, founder $founder. Expect the Pulses row in 2 to 4 minutes."
else
  echo "Webhook returned HTTP $code: $(head -c 300 "$resp")" >&2; exit 1
fi
