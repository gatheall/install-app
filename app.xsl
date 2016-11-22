<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output
 method="html" indent="yes" encoding="ISO-8859-1"
 doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"/>


<xsl:variable name="title">
    Application Information
    <xsl:choose>
        <xsl:when test="app/name"> for <xsl:value-of select="app/name"/></xsl:when>
        <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
</xsl:variable>


<xsl:template match="/">

<HTML>
<HEAD>
<TITLE><xsl:value-of select="$title"/></TITLE>
</HEAD>

<BODY>

<H2><xsl:value-of select="$title"/></H2>

<xsl:apply-templates select="app/install"/>

</BODY>
</HTML>

</xsl:template>


<xsl:template match="app/install">

<H3>Installation</H3>

<P>There are <xsl:value-of select="count(step)"/> steps.</P>

<xsl:if test="count(step) &gt; 0">

<H4>Steps</H4>

<CENTER><TABLE BORDER="1">
   <TR>
      <TH>Step </TH>
      <TH>Label </TH>
      <TH>Action </TH>
      <TH>Comment<BR/></TH>
   </TR>
<xsl:apply-templates select="step"/>
</TABLE></CENTER>
</xsl:if>


<P>There are <xsl:value-of select="count(versions)"/> versions installed.</P>

<xsl:if test="count(versions) &gt; 0">

<H4>Version History</H4>

<CENTER><TABLE BORDER="1">
   <TR>
      <TH>Version </TH>
      <TH>Date </TH>
      <TH>User<BR/></TH>
   </TR>
<xsl:apply-templates select="versions"/>
</TABLE></CENTER>
</xsl:if>
</xsl:template>


<xsl:template match="/app/install/step">
   <TR>
      <TH><xsl:number/> </TH>
      <TD><xsl:value-of select="label"/> </TD>
      <TD><xsl:value-of select="action"/> </TD>
      <TD><xsl:value-of select="comment"/><BR/></TD>
   </TR>
</xsl:template>


<xsl:template match="/app/install/versions">
   <TR>
      <TH><xsl:value-of select="version"/> </TH>
      <TD><xsl:value-of select="date"/> </TD>
      <TD><xsl:value-of select="user"/><BR/></TD>
   </TR>
</xsl:template>


</xsl:stylesheet>
