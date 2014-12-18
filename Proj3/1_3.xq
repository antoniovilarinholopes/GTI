declare function local:cleanPoliticians($politiciansList, $clusters) {
<politicians>
{
let $cleanedPoliticians := (
	for $politician in $politiciansList//politician
	return 
		let $occurrenceInCluster := (
			for $cluster in $clusters//cluster
			return 
				if (some $nodeInSeq in $cluster//politician satisfies deep-equal($nodeInSeq, $politician))
				then local:getPoliticianFromCluster($cluster)
				else ())
		return
			if (empty($occurrenceInCluster))
			then $politician
			else $occurrenceInCluster
		)
return local:distinct-nodes($cleanedPoliticians)
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

declare function local:distinct-nodes ($arg as node()*) as node()* {
 for $a at $apos in $arg
 let $before_a := fn:subsequence($arg, 1, $apos - 1)
 where every $ba in $before_a satisfies not(deep-equal($ba,$a))
 return $a
};

(:
let $politicians := (
<politicians>
	<politician name="A" party="P" />
	<politician name="B" party="PS" />
	<politician name="D" party="PS" />
	<politician name="F" party="OLA" />
</politicians>
)
:)

let $politicians := doc("file:///afs/ist.utl.pt/users/2/1/ist173721/GTI/Proj3/Politicians.xml")

(:
let $clusters := (
<clusters>
	<cluster>
		<politician name="AB" party="PSX" />
		<politician name="A" party="P" />
		<politician name="B" party="PS" />
		<politician name="AC" party="x" />
	</cluster>
	<cluster>
		<politician name="D" party="PS" />
		<politician name="DRE" party="y" />
		<politician name="E" party="PS" />
	</cluster>
</clusters>
)
:)

let $clusters := doc("file:///afs/ist.utl.pt/users/2/1/ist173721/GTI/Proj3/clusters.xml")

return local:cleanPoliticians($politicians, $clusters)

