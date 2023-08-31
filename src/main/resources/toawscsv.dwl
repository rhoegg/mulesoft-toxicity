%dw 2.0
import substringAfter from dw::core::Strings
input payload text/plain
output application/csv header=false
//output application/json
var rawPayload = read(payload, "text/plain") substringAfter 'text,is_toxic\r\n'
var rows = rawPayload splitBy "Toxic\r\n" map {
	toxic: $ endsWith ",",
	text: ($ match /(?s)(.*),(Not )?/)[1]
}
var trainingData = rows map (row) -> {
	text: row.text
		replace /^"""/ with '"`'
		replace /"""/ with '`"'
		replace /""/ with '`'
		replace /\r?\n/ with '   '
		replace /,/ with '  ',
	is_toxic: if (row.toxic) "Toxic" else "Not Toxic"
}
---
trainingData map {
    label: $.is_toxic,
    text: $.text 
}
