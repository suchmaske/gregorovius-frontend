<xsl:template match="/">
    <xsl:apply-templates select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:p[2]"/>
</xsl:template> 