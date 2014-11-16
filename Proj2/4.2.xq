declare function ns:naive-bayes
  ( $model as xs:node(), $speech as xs:string ) {


   (:vocab size:)
   let $vocab_size := count(for $word_token in $model//word
			return $word_token
			)

   (:each word in speech prob:)
   let $words_in_speech := tokenize($speech/text(), "\W+")
   let $word_prob_party := (for $word in $words_in_speech
		       
		
		)
	
    
    return <model>
	{for $interventions_of_party_member in $interventions_of_party_members
	return  $interventions_of_party_member}
          {for $word_token in $word_tokens
	return  $word_token}
	</model>	

 } ;