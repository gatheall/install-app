<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:text="dont care"
 exclude-result-prefixes="text" >
<xsl:output
 method="html" indent="yes" encoding="iso-8859-1"
 doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"/>
<xsl:strip-space elements="*"/>

<!--
-->

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>


<xsl:template match="/">

<H2>Application Information</H2>

<P>The stylesheet is currently under development.</P>

</xsl:template>


</xsl:stylesheet>
