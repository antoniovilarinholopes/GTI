declare function ns:word-count
  ( $speeches as xs:string? )  as xs:integer {


   (:get all partys:)
   let $partys := fn:distinct-values(for $speech, $politician in $speeches, $politicians
   		 where $speech[@politician = $politician/@code]
                     group by ($politician/@party)
		 return $politician/@party)

   (:number of interventions:)
   let $interventions_of_party_members := (for $party in $partys
                                           let $number_interventions := count(for $speech, $politician in $speeches, $politicians
							      where $politician/@party = $party and [speech/@politician=$politician/@code]
							      return $party)
				  return <party
					name="{$party}"
					size="{$number_interventions}"
					>
		 		         </party>)
		
   (:get all words:)
   let $words := (for $speech in $speeches
	       let $words := split($speech, " ")
                 group by($words)
                 return $words)
   
     
    let $words_normalized := fn:lowercase(fn:distinct-values($words));
    (:party with words:)
    


 } ;