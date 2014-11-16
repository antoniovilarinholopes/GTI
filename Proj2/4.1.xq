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
	       let $words := fn:tokenize($speech/text(), "\W+")
                 group by($words)
                 return $words)
   
     
    let $words_normalized := fn:distinct-values(fn_lowercase($words));
    (:party with words:)
    let $word_tokens := (for $word in $words_normalized
                        let $party_word_count := (for $party in $partys
                                                  return <party
				                name="{$party}">
					      {count(for $speech, $politician in $speeches, $politicians
							     where $speech[@politican = $politician/@code] 
								and $politican[@party = $party] 
								and contains($speech/text(), $word)
							     return $speech 
							)}
					     </party>
					 )
		  return <word
			token="{$word}"
			>
			{for $party in $party_word_count
			return $party}
			</word>    
			)
    
    return <model>
	{for $interventions_of_party_member in $interventions_of_party_members
	return  $interventions_of_party_member}
          {for $word_token in $word_tokens
	return  $word_token}
	</model>	

 } ;