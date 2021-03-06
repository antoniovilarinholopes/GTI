declare namespace ns = "http://www.parlamento.pt"

let $pcode := //ns:politicians/ns:politician[contains(., "José Seguro")]/@code
return
	let $s := //ns:session/ns:speech[@politician=$pcode]/following-sibling::*[1]
	return
		for $speech in $s
		let $politician := $speech/@politician
		group by $politician
		where count($speech) >= 2
		return
			let $p := //ns:politician[@code=$politician]
			return concat("name: ", $p/text(), " party: ", $p/@party)