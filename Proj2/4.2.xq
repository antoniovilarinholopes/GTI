declare function ns:naive-bayes
  ( $model as xs:node(), $speech as xs:string ) {


   (:vocab size:)
   let $vocab_size := count(	for $word_token in $model//word
			return $word_token
			)

   (:each word in speech:)
   
   let $all_words_in_speech := fn:tokenize($speech/text(), "(\.|\!|\?|\,|\:|[ ]+)")
       
   let $words_normalized_in_speech := ( for $word in $all_words return if(string($word) = '') then () else fn:lower-case($word) )

  
    (:naive-bayes:)
    
    (:party prob:)
    let $total_partys_intervention := fn:sum( for $party in $model//party return $party/@size )
    let $party_probs := (	for $party in $model//party
		    	return 
			<party_prob
			party="{$party/@name}"
			prob="{fn:div($party/@size, $total_partys_intervention)}"
			>
			</party_prob>
		   )
    (:words prob:)
    let $word_probs := (	for $word_in_speech in $words_normalized_in_speech, $word in $model//word
                        	return 
				if($word_in_speech = $word/@token)
				then
                               		(for $party in $word//party, $word_partys_count in $word//party
                               		where $party[@name = $word_partys_count/@name]
					let $total_occ_word := (for $party_2 in $word_partys_count//party return sum(numeric($party_2/text())))
					return				
					<word_prob 
					token="{$word_in_speech}"
                               		party="{$party/@name}"
					occ="{$party/text()}"
					totalocc="{total_occ_word}"
					prob="{fn:div($party/text(), $total_occ_word)}"
					>
					</word_prob>)
				else
					(for $party in $word//party
					return
					<word_prob 
					token="{$word_in_speech}"
                               		party="{$party/@name}"
					occ="0"
					totalocc="0"
					prob="{fn:div(1, $vocab_size)}"
					>
					</word_prob>)
    			)
   
    (:calc each party prob:)
    let $party_naive_bayes_prob := ( 	for $party_prob in $party_probs, $word_prob in $word_probs
				return
					<naive_bayes_party_prob
					party="{$party_prob/@party}"
					prob="{mul($party_prob/@prob, (for $word_prob in $word_probs 	where $party_prob[@party = $word_prob/@party return  $word_prob/@prob))}"
					>
					</naive_bayes_party_prob>
				)

   (:return max:)


};


