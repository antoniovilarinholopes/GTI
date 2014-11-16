declare function ns:word-count
  ( $speeches as xs:string? )  as xs:integer {


   (::)
   let $partys := 	(for $speech, $politician in $speeches, $politicians
   		 where $speech[@politician = $politician/@code]
                     group by ($politician/@party)
		 return $politician/@party)
   let $interventions_of_party_members := count(for $party, $speech, $politician in $partys, $speeches, $politicians
		where $politician/@party = party and [speech/@politician=$politician/@code]
		return)

 } ;