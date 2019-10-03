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

    <xsl:strip-space elements="*" />
    
    <!-- Select source description element -->
    <xsl:template match="/">
        <xsl:apply-templates select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc"/>
    </xsl:template>

    <!-- Hide physical description -->
    <xsl:template match="tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc"/>

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

</xsl:stylesheet>