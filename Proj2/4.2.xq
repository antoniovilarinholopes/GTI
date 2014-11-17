declare function ns:naive-bayes
  ( $model as xs:node(), $speech as xs:string ) {


   (:vocab size:)
   let $vocab_size := count(for $word_token in $model//word
			return $word_token
			)

   (:each word in speech:)
   
   let $all_words_in_speech := fn:tokenize($speech/text(), "(\.|\!|\?|\,|\:|[ ]+)")
       
   let $words_normalized_in_speech := fn:distinct-values(for $word in $all_words return if(string($word) = '') then () else fn:lower-case($word))

   (::)
   let $words_partys := (for $word in $words_normalized_in_speech, $words in $model//word
		     where $words[@token = $word]
		     return $words;
		    )
    (:naive-bayes:)
    
    (:party prob:)
    let $total_partys_intervention := sum(for $party in $model//party return $party/@size)
    let $party_prob := (for $party in $model//party
		    return
			if($party[@size = 0]) then
			(:smoothing:) ()
                               else  
    			 op:double-divide($party/@size, $total_partys_intervention)
		   )
    (:words prob:)
    let $word_probs := (for $word_in_speech in $words_normalized_in_speech, $word in $model//word
                        where $word[@token = $word_in_speech]
                        return 
                               for $party in $word//party
			let $total_occ_word := (for $party_2 in $word//party return sum(numeric($party_2/text())))
                               return 
			<word_prob 
                               party="{$party}"
			prob="{}">

			</word_prob>
		

    )
    (:evidence:)
     

 } ;