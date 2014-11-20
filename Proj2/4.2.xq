declare function local:multiplytail($seq, $i, $res) {
  if ($i le 0) then $res
  else local:multiplytail($seq, $i - 1, $res*number($seq[$i]))
};

declare function local:multiply($seq) {
  local:multiplytail($seq, count($seq), 1)
};

declare function local:naive-bayes
  ( $model, $speech as xs:string ) {


  (:vocab size:)
  let $vocab_size := count(	for $word_token in $model//word
				return $word_token
			  )

   


   (:each word in speech:)
   
   let $all_words_in_speech := fn:tokenize($speech, "(\.|\!|\?|\,|\:|[ ]+)")
       
   let $words_normalized_in_speech := ( for $word in $all_words_in_speech 
					return
					  if(string($word) = '')
					  then 
					    ()
					  else
					  fn:lower-case($word) )

  
    (:naive-bayes:)
   
    (:party prob:)
    let $total_partys_intervention := fn:sum( for $party in $model/model/party 
					      return $party/@size )
    let $party_probs := (	for $party in $model/model/party
				return 
				<party_prob
				  party="{$party/@name}"
				  prob="{($party/@size div $total_partys_intervention)}"
				>
				</party_prob>
			)
    

    (:words prob:)
    let $word_probs := (	for $word_in_speech in $words_normalized_in_speech
				let $number_of_occ_in_model := fn:count(	for $word in $model//word
										where $word[@token = $word_in_speech]
										return $word	)
                        	return 
				if($number_of_occ_in_model > 0)
				then
                               		(for $word in $model//word, $party in $word//party
                               		where $word[@token = $word_in_speech]
					let $total_occ_word := sum(for $party_2 in $word//party return number($party_2/text()))
					return				
					<word_prob 
					  token="{$word_in_speech}"
					  party="{$party/@name}"
					  occ="{$party/text() + 1}"
					  totalocc="{$total_occ_word}"
					  prob="{($party/text() + 1) div ($total_occ_word + $vocab_size)}"
					>
					</word_prob>)
				else
					(for $party in $model/model/party
					return
					<word_prob 
					  token="{$word_in_speech}"
					  party="{$party/@name}"
					  occ="0"
					  totalocc="0"
					  prob="{(1 div $vocab_size)}"
					>
					</word_prob>)
    			)



    (:calc each party prob:)
    let $party_naive_bayes_probs := (	for $party_prob in $party_probs
					let $prob_words_party := (for $word_prob in $word_probs
								  where $word_prob/@party = $party_prob/@party
								  return $word_prob/@prob)
					return 
					<naive_bayes party="{$party_prob/@party}" prob="{$party_prob/@prob * local:multiply($prob_words_party)}" />
				    )

   (:return max:)


   let $max := fn:max( for $prob in $party_naive_bayes_probs//@prob return $prob )

   return (for $party_naive_bayes_prob in $party_naive_bayes_probs where $party_naive_bayes_prob[@prob = $max] return $party_naive_bayes_prob)

};

local:naive-bayes(doc("file:///afs/ist.utl.pt/users/2/1/ist173721/GTI/Proj2/model.xml"), "Reply to the previous reply.")
