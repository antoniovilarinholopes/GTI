declare function local:processClusterList($clusters) {
let $processedCluster := 
	(
		for $position in 1 to fn:count($clusters)
		return local:processCluster($clusters, $position)
	)

let $removedElementDuplicates := 
	(
		for $elem in $processedCluster	
		return local:removeDuplicatedElements($elem)
	)

let $removedClusterDuplicates := local:removeDuplicatedClusters($removedElementDuplicates)

return 
	if (deep-equal($clusters, $removedClusterDuplicates))
	then $removedClusterDuplicates
	else local:processClusterList($removedClusterDuplicates)
};


declare function local:removeDuplicatedClusters($clusterList) {
	for $position in 1 to count($clusterList)
	where not(some $nodeInSeq in subsequence($clusterList, $position+1) satisfies local:sequence-node-equal-any-order($nodeInSeq/politician,$clusterList[$position]/politician))
	return $clusterList[$position]
};

declare function local:sequence-node-equal-any-order($seq1, $seq2) as xs:boolean {
	let $diff1 := (for $elem1 in $seq1
		where not(local:is-node-in-sequence($elem1, $seq2))
		return $elem1)
	let $diff2 := (for $elem2 in $seq2
		where not(local:is-node-in-sequence($elem2, $seq1))
		return $elem2)
	return empty(($diff1, $diff2))
};

declare function local:removeDuplicatedElements($cluster) {
<cluster>
{for $position in 1 to count($cluster/politician)
where not(local:is-node-in-sequence($cluster/politician[$position], subsequence($cluster/politician, $position+1)))
return $cluster/politician[$position]}
</cluster>
};

declare function local:is-node-in-sequence($node as node()?, $seq as node()* )  as xs:boolean {
   some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq,$node)
};

(: returns a new cluster as a result of joining with the rest of the clusters :)
declare function local:processCluster($clusters, $clusterPosition) {
	let $list := (
		for $position in ((1 to $clusterPosition - 1),($clusterPosition+1 to fn:count($clusters)))
		return		
			if(local:isSimiliarClusters($clusters[$position], $clusters[$clusterPosition]))
			then 
				<cluster>
				{
				(for $politician in $clusters[$position]//politician
				return $politician,
				for $politician in $clusters[$clusterPosition]//politician
				return $politician)
				}
				</cluster>
			else())
	return
		if(empty($list))
		then $clusters[$clusterPosition]
		else $list

};

(: a cluster is similiar with another if it has at least one equal element :)
declare function local:isSimiliarClusters($cluster1, $cluster2) {
let $commonElements := 
	(for $element1 in $cluster1//politician, $element2 in $cluster2//politician
	 where deep-equal($element1 , $element2)
	 return $element1)
return not(empty($commonElements))
};

local:processClusterList((<pair><politician name="a" party="PSD"/><pair name="b" party="PS"/><politician name="c" party="PSD"/></pair>,<pair><politician name="b" party="PS"/><politician name="c" party="PSD"/></pair>,<pair><politician name="d" party="PSD"/><politician name="e" party="PSD"/></pair>))
