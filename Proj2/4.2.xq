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
   let $words_in_model := (for $word in $words_normalized_in_speech, $words in $model//word
		     where $words[@token = $word]
		     return $words;
		    )

    (:naive-bayes:)
    
    (:party prob:)
    let $total_partys_intervention := sum(for $party in $model//party return $party/@size)
    let $party_prob := (for $party in $model//party
		    return
    			 op:double-divide($party/@size, $total_partys_intervention)
		   )
    (:words prob:)
    let $word_probs := (for $word_in_speech in $words_normalized_in_speech, $word in $model//word
                        where $word[@token = $word_in_speech]
                        return 
                               (for $party in $word//party, $word_partys_count in $word//party
                               where $party[@name = $word_partys_count/@name]
			let $total_occ_word := (for $party_2 in $word_partys_count//party return sum(numeric($party_2/text())))
			return 
			(:smoothing missing:)
			<word_prob 
			token="{$word_in_speech}"
                               party="{$party/@name}"
			occ="{$party/text()}"
			totalocc="{total_occ_word}"
			prob="{op:double-divide($party/text(), $total_occ_word)}"
			>
			</word_prob>)
		
    			)
    (:evidence:)
     

};


