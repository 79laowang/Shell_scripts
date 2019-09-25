#!/bin/bash

cat > test.json <<EOF
{
  "bugs": [
    {
      "bug_verify": "",
      "bug_id": "43"
    },
    {
      "bug_verify": "",
      "bug_id": "44"
    },
    {
      "bug_verify": "",
      "bug_id": "45"
    }
  ],
}
EOF

# Modify spedified item value.
BUB=43
jq -r --arg BUG "$BUG" '.bugs[]|select(.bug_id == $BUG).bug_verify="failed"' test.json
