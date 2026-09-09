#!/usr/bin/env bash
# Study 40 — pull the OpenFEMA NFIP claims corpus, exactly and reproducibly.
#
# Public, anonymous, no key. The dataset is paged; every page is requested with an
# explicit $orderby so the ordering is the archive's and not the server's mood, and the
# pages are concatenated in order. A stranger running this gets the same bytes, or the
# archive has been revised — which is itself the measurement Analysis 4 makes.
set -euo pipefail
OUT="${1:-nfip-claims.csv}"
PAGE="${PAGE:-10000}"
BASE="https://www.fema.gov/api/open/v2/FimaNfipClaims.csv"
SEL='dateOfLoss,yearOfLoss,state,countyCode,censusTract,latitude,longitude,buildingDamageAmount,contentsDamageAmount,amountPaidOnBuildingClaim,amountPaidOnContentsClaim,amountPaidOnIncreasedCostOfComplianceClaim,buildingDeductibleCode,contentsDeductibleCode,totalBuildingInsuranceCoverage,totalContentsInsuranceCoverage,waterDepth,causeOfDamage,ratedFloodZone,occupancyType,asOfDate'
TOTAL=$(curl -sL -m 60 "https://www.fema.gov/api/open/v2/FimaNfipClaims?\$top=1&\$inlinecount=allpages" \
        | sed -n 's/.*"count":\([0-9]*\).*/\1/p')
echo "archive reports $TOTAL records" >&2
: > "$OUT"
skip=0; first=1
while [ "$skip" -lt "$TOTAL" ]; do
    url="$BASE?\$select=$SEL&\$orderby=id&\$top=$PAGE&\$skip=$skip"
    tmp=$(mktemp)
    curl -sL --retry 4 --retry-delay 2 -m 300 "$url" -o "$tmp"
    if [ "$first" = 1 ]; then cat "$tmp" >> "$OUT"; first=0; else tail -n +2 "$tmp" >> "$OUT"; fi
    rm -f "$tmp"
    skip=$((skip + PAGE))
    printf '\r  %s / %s' "$skip" "$TOTAL" >&2
done
echo "" >&2
echo "rows written: $(( $(wc -l < "$OUT") - 1 ))" >&2
shasum -a 256 "$OUT"
