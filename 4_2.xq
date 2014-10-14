declare namespace ns = "http://www.parlamento.pt"

declare function ns:word-count
  ( $arg as xs:string? )  as xs:integer {

   count(tokenize($arg, '\W+')[. != ''])
 } ;

for $speech in doc("Parlamento.xml")//ns:speech
let $wordcount := ns:word-count($speech/text())
order by $wordcount descending
return $speech

