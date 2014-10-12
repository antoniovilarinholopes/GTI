<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:p="http://www.parlamento.pt">

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
          <th>Name</th>
          <th>Age</th>
          <th>Code</th>
          <th>Party</th>
        </tr> 
         <xsl:apply-templates /> 
        </table> 
</xsl:template>

<xsl:template match="p:politicians/p:politician">
        <tr>
		<td> <xsl:value-of select="." /> </td> 
		<td> <xsl:value-of select="@age" /> </td>
		<td> <xsl:value-of select="@code" /> </td>
		<td> <xsl:value-of select="@party" /> </td> 
	</tr>
</xsl:template>

<xsl:template match="*">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="text()">
</xsl:template>

</xsl:stylesheet>
