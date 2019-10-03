<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:func="http://exslt.org/functions"
    extension-element-prefixes="func"
    xmlns:telota="http://www.telota.de" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:v-bind="https://vuejs.org/v2/api/#v-bind"
    xmlns:v-on="https://vuejs.org/v2/api/#v-on"
    version="3.0" 
    exclude-result-prefixes="tei">

    <xsl:template match="/tei:bibl/tei:title">
        <xsl:apply-templates/>
    </xsl:template> 

    <xsl:template match="tei:hi[@rendition = '#i']">
        <i><xsl:apply-templates/></i>
    </xsl:template> 

    <xsl:template match="tei:hi[@rendition = '#b']">
        <b><xsl:apply-templates/></b>
    </xsl:template> 

    <xsl:template match="tei:hi[@rendition = '#i #b']">
        <i><b><xsl:apply-templates/></b></i>
    </xsl:template> 

    <xsl:template match="tei:hi[@rendition = '#s']">
        <sup><xsl:apply-templates/></sup>
    </xsl:template> 

    <xsl:template match="/tei:bibl/tei:note"/>

</xsl:stylesheet>