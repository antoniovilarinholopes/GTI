declare function local:cleanPoliticians($politiciansList, $clusters) {
<politicians>
{
let $cleanedPoliticians := (
	for $politician in $politiciansList//politician
	return for $cluster in $clusters//cluster
		return 
			if (some $nodeInSeq in $cluster//politician satisfies deep-equal($nodeInSeq, $politician))
			then local:getPoliticianFromCluster($cluster)
			else $politician)
return $cleanedPoliticians (:local:removeDuplicatedElements($cleanedPoliticians) :)
}
</politicians>
};

declare function local:getPoliticianFromCluster($cluster) {
<politician 
name="{
	let $maxLength := max(for $politicianName in $cluster//politician/@name
			  return string-length($politicianName))
	let $biggestName := (for $politician in $cluster//politician
	where string-length($politician/@name) = $maxLength
	return $politician/@name)
	return $biggestName[1]
}" party="{
	let $minLength := min(for $politicianParty in $cluster//politician/@party
			  return string-length($politicianParty))
	let $shortestParty := (for $politician in $cluster//politician
	where string-length($politician/@party) = $minLength
	return $politician/@party)
	return $shortestParty[1]
}"/>
};

declare function local:removeDuplicatedElements($politiciansList) {
for $position in 1 to count($politiciansList/politician)
where not(local:is-node-in-sequence($politiciansList/politician[$position], subsequence($politiciansList/politician, $position+1)))
return $politiciansList/politician[$position]
};

declare function local:is-node-in-sequence($node as node()?, $seq as node()* )  as xs:boolean {
   some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq, $node)
};


let $politicians := (
<politicians>
	<politician name="A" party="PS" />
	<politician name="D" party="PS" />
</politicians>
)

let $clusters := (
<clusters>
	<cluster>
		<politician name="A" party="P" />
		<politician name="B" party="PS" />
		<politician name="AC" party="PS" />
	</cluster>
	<cluster>
		<politician name="D" party="PS" />
		<politician name="E" party="PS" />
	</cluster>
</clusters>
)
(:return local:getPoliticianFromCluster($clusters/cluster[1]):)
return local:cleanPoliticians($politicians, $clusters)

