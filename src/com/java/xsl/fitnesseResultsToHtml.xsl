<?xml version="1.0" encoding="UTF-8" ?>
<!-- Written by Gregor Gramlich -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output method="html"/>
   <xsl:param name="baseUrl">http://localhost:8065/</xsl:param>

<xsl:template match="suiteResults">
<html>
	<head>
		<title>
            <xsl:if test="finalCounts">Suite</xsl:if>
            <xsl:if test="not (finalCounts)">Test</xsl:if>
            Results:
            <xsl:value-of select="rootPath" />
        </title>
        <xsl:call-template name="css_and_javascript" />
	</head>
	<body>
		<div class="header">
		    <br />
		    <span class="page_title"><xsl:value-of select="rootPath" /></span>
		    <br />
		    <span class="page_type">
                <xsl:if test="finalCounts">Suite</xsl:if>
                <xsl:if test="not (finalCounts)">Test</xsl:if>
		        Results
            </span>
		</div>
        <div class="main">
            <xsl:if test="finalCounts">
                <xsl:call-template name="summary"/>
            </xsl:if>
        </div>
    </body>
</html>
</xsl:template>

<xsl:template name="summary">
    <xsl:apply-templates select="finalCounts" mode="div"/>
    <h2 class="centered">Test Summaries</h2>
    <div id="test_summaries" class="test_summaries">
        <xsl:apply-templates select="pageHistoryReference" mode="summary"/>
    </div>

</xsl:template>

<xsl:template match="pageHistoryReference" mode="summary">
    <div>
        <xsl:attribute name="class">alternating_row_<xsl:value-of select="2-(position() mod 2)" /></xsl:attribute>
        <xsl:apply-templates select="counts" mode="span"/>
        <xsl:variable name="xmlLink"  select="pageHistoryLink" />
                
        <a class="test_summary_link">
           <xsl:attribute name="href"><xsl:value-of select="$baseUrl"/><xsl:value-of select="concat($xmlLink,'=html')"/></xsl:attribute>
            <xsl:value-of select="name" />
        </a>

       (<xsl:value-of select="runTimeInMillis div 1000" /> seconds)

    </div>
</xsl:template>

<xsl:template match="pageHistoryReference" mode="test">
        <div class="test_output_name">
            <a>
                <xsl:attribute name="id"><xsl:value-of select="name" /></xsl:attribute>
                <xsl:value-of select="name" />
            </a>
        </div>
        <div>
            <xsl:attribute name="class">alternating_block_<xsl:value-of select="2-(position() mod 2)" /></xsl:attribute>
            <xsl:if test="not (//suiteResults/finalCounts)">
                <xsl:apply-templates select="counts" mode="div"/>
            </xsl:if>
            <xsl:value-of select="content" disable-output-escaping="yes" />
        </div>
</xsl:template>

<xsl:template match="counts" mode="span">
        <span>
            <xsl:attribute name="class">
                test_summary_results <xsl:call-template name="summary_class" />
            </xsl:attribute>
            <xsl:call-template name="summary_contents" />
        </span>
</xsl:template>

<xsl:template match="finalCounts|counts" mode="div">
        <div id="test-summary">
            <xsl:attribute name="class">
                <xsl:call-template name="summary_class" />
            </xsl:attribute>
            <strong>Assertions:</strong>
            <xsl:call-template name="summary_contents" />
        </div>
</xsl:template>

<xsl:template name="summary_class">
    <!-- See TestHtmlFormatter.cssClassFor() -->
    <xsl:choose>
        <xsl:when test="wrong &gt; 0">fail</xsl:when>
        <xsl:when test="exceptions &gt; 0 or (right + ignores) = 0">error</xsl:when>
        <xsl:when test="ignores &gt; 0 or right = 0">ignore</xsl:when>
        <xsl:otherwise>pass</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="summary_contents">
    <xsl:value-of select="right" /> right,
    <xsl:value-of select="wrong" /> wrong,
    <xsl:value-of select="ignores" /> ignored, 
    <xsl:value-of select="exceptions" /> exceptions
</xsl:template>
</xsl:stylesheet>

