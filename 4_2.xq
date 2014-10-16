declare namespace ns = "http://www.parlamento.pt"

declare function ns:word-count
  ( $arg as xs:string? )  as xs:integer {

   count(tokenize($arg, '\W+')[. != ''])
 } ;

let $sortedSpeech := (
	for $speech in doc("Parlamento.xml")//ns:speech
	let $wordcount := ns:word-count($speech/text())
	order by $wordcount descending
	return $speech)
return <interventions>
	{for $s at $pos in $sortedSpeech[position() <= 5]
	let $politician := //ns:politician[@code=$s/@politician] 
	return <intervention
		session-date="{//ns:session[ns:speech=$s]/@date}"
		party="{$politician/@party}"
		politician="{$politician/text()}"
		rank-order="{$pos}"
		>{$s/text()}
		</intervention>
	}
       </interventions>
