%dw 2.0
input payload text/plain
output application/json
var rawPayload = read(payload, "text/plain")
var escapedPayload = rawPayload replace /""/ with '\"'
var trainingData = read(escapedPayload, "application/csv")
---
trainingData map {
    text: $.text,
    labels: [$.is_toxic]
}
