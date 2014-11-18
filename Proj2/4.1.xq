declare namespace ns = "http://www.parlamento.pt"

declare function local:model( $doc ) {


   (:get all partys:)
   let $partys := distinct-values( $doc//ns:politician/data(@party) )



   (:number of interventions:)
   let $interventions_of_party_members := (for $party in $partys
                                          let $number_interventions := count(for $speech in $doc//ns:speech, $politician in $doc//ns:politician
	                                 			 where $politician[@party = $party] and $speech[@politician=$politician/@code]
			             			 return $speech)
                               	 return <party
					name="{$party}"
					size="{$number_interventions}"
					>
					</party>)


   (:get all words:)


   let $all_words := (for $speech in $doc//ns:speech
	       let $words := fn:tokenize($speech/text(), "(\.|\!|\?|\,|\:|[ ]+)")
                 return $words)

   let $words_normalized := fn:distinct-values(for $word in $all_words return if(string($word) = '') then () else fn:lower-case($word))

(:party with words:)
    let $word_tokens := (for $word in $words_normalized
                        let $party_word_count := (for $party in $partys
                                                  return <party
				                name="{$party}">
					      {count(for $speech in $doc//ns:speech, $politician in $doc//ns:politician
							     where $politician[@party = $party] 
								and $speech[@politician = $politician/@code] 
								and fn:contains(fn:lower-case($speech/text()), $word)
							     return $speech 
							)}
					     </party>
					 )
		  return <word
			token="{$word}"
			>
			{for $party_word in $party_word_count
			return $party_word}
			</word>    
			)
    
    return <model>
	{for $interventions_of_party_member in $interventions_of_party_members
	return  $interventions_of_party_member}
          {for $word_token in $word_tokens
	return  $word_token}
	</model>

};


local:model(doc("file:///home/antonio/GTI/Proj1/Parlamento.xml"))
(:local:model(doc("file:///afs/ist.utl.pt/users/2/1/ist173721/GTI/Proj1/Parlamento.xml")):)

