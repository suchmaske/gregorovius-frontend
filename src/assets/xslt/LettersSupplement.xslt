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

    <xsl:template match="/">
        <xsl:apply-templates select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:p[2]"/>
    </xsl:template> 

</xsl:stylesheet>