<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:p="http://www.parlamento.pt">

<xsl:output method="html" encoding="UTF-8" indent="yes" media-type="text/html"/>

<xsl:template match="/">
	<html>
	<body>
	<h2>Politicians</h2>
	
	<xsl:apply-templates />
	</body>
	</html>
</xsl:template>

<xsl:template match="p:politicians">
	<table border="1">
         <tr bgcolor="#9acd32">
          <th>Code</th>
          <th>Party</th>
          <th>Age</th>
          <th>Name</th>
          <th>N.º of Interventions</th>
          <th>N.º of Sessions</th>
        </tr> 
         <xsl:apply-templates /> 
        </table> 
</xsl:template>

<xsl:template match="p:politicians/p:politician">
	<xsl:param name="code" select="@code"/>
    <tr>
       	<td> <xsl:value-of select="$code" /> </td>
		<td> <xsl:value-of select="@party" /> </td>
		<td> <xsl:value-of select="@age" /> </td>
		<td> <xsl:value-of select="." /> </td>
		<td> <xsl:value-of select="count(//p:speech[@politician=$code])" /></td>
		<td> <xsl:value-of select="count(//p:session[p:speech/@politician=$code])" /></td>
	</tr>
</xsl:template>

<xsl:template match="*">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="text()">
</xsl:template>

</xsl:stylesheet>
