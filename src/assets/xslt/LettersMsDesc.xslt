<xsl:strip-space elements="*" />

<!-- Select source description element -->
<xsl:template match="/">
    <xsl:apply-templates select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc"/>
</xsl:template>

<!-- Select physical description -->
<xsl:template match="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc">
    <p><xsl:apply-templates select="tei:p[1]"/></p>
</xsl:template> 


<!-- Render manuscript (Handschrift) -->
<xsl:template match="tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier">
    <xsl:choose>
        <xsl:when test="string()">
            <p>
                <b>H</b>: 
                <xsl:for-each select="./*">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
            </p>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template> 

<!-- Render copies (Abschriften) -->
<xsl:template match="tei:fileDesc/tei:sourceDesc/tei:listWit//tei:witness/tei:msDesc[@type='copy']">
    <xsl:choose>
        <xsl:when test="string()">
            <p>
                <b>h</b>: 
                <xsl:for-each select="./*/*">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
            </p>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template> 

<!-- Render prints (Drucke) -->
<xsl:template match="tei:fileDesc/tei:sourceDesc/tei:listWit//tei:witness/tei:bibl[@type='print']">
    <xsl:choose>
        <xsl:when test="string()">
            <p>
                <b>D</b>: 
                <xsl:for-each select="text()"><xsl:value-of select="."/></xsl:for-each>
            </p>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template> 

<!-- Render concepts (Konzepte) -->
<xsl:template match="tei:fileDesc/tei:sourceDesc/tei:listWit//tei:witness/tei:msDesc[@type='concept']">
    <xsl:choose>
        <xsl:when test="text()">
            <p>
                <b>K</b>: 
                <xsl:apply-templates/>
            </p>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template> 