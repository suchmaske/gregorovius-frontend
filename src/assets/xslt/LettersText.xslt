<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:telota="http://www.telota.de" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:v-bind="https://vuejs.org/v2/api/#v-bind"
    xmlns:v-on="https://vuejs.org/v2/api/#v-on"
    version="3.0" 
    exclude-result-prefixes="tei">

    <xsl:template match="/">
        <xsl:apply-templates select="//tei:body"/>
    </xsl:template> 


    <!-- Page breaks -->

    <xsl:template match="tei:pb">
        |
        <span class="pb">
            <xsl:apply-templates select="./@n" />
        </span>
    </xsl:template>

    <!-- Opener and closer elements -->

    <xsl:template match="tei:signed | tei:salute | tei:dateline | tei:note[@type='postscript']">
        <xsl:choose>
            <xsl:when test="@rendition = '#right'">
                <p class="text-right"> <xsl:apply-templates/> </p>
            </xsl:when>
            <xsl:when test="@rendition = '#c'">
                <p class="text-center"> <xsl:apply-templates/> </p>
            </xsl:when>
            <xsl:otherwise>
                <p> <xsl:apply-templates/> </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> 

    <!-- Letter body -->

    <xsl:template match="tei:p">
        <xsl:choose>
            <xsl:when test="@xml:id | @prev | @next">
                <p class="coupled"> <xsl:apply-templates/> </p>
            </xsl:when>
            <xsl:when test="@rendition = '#right'">
                <p class="text-right"> <xsl:apply-templates/> </p>
            </xsl:when>
            <xsl:when test="@rendition = '#c'">
                <p class="text-center"> <xsl:apply-templates/> </p>
            </xsl:when>
            <xsl:when test="@rendition = '#et'">
                <p class="ml-4"> <xsl:apply-templates/> </p>
            </xsl:when>
            <xsl:otherwise>
                <p> <xsl:apply-templates/> </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:add">
        <span class="add"> <xsl:apply-templates/> </span>
    </xsl:template> 

    <xsl:template match="tei:del[@rendition='#s']">
        <del> <xsl:apply-templates/> </del>
    </xsl:template> 

    <xsl:template match="tei:hi[@rendition='#u']">
        <u> <xsl:apply-templates/> </u>
    </xsl:template> 

    <xsl:template match="tei:hi[@rendition='#aq']">
        <span class="aq"> <xsl:apply-templates/> </span>
    </xsl:template> 

    <xsl:template match="tei:ex">
        <em> <xsl:apply-templates/> </em>
    </xsl:template> 

    <xsl:template match="tei:lb">
        <br/>
    </xsl:template> 

    <xsl:template match="tei:persName">
        <xsl:choose>
            <xsl:when test="@key">
                <a class="g-entity-link" v-on:click="$router.push({{ name: 'Person', params: {{ id: '{@key}' }} }})">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:orgName">
        <xsl:choose>
            <xsl:when test="@key">
                <a class="g-entity-link" v-on:click="$router.push({{ name: 'Körperschaft', params: {{ id: '{@key}' }} }})">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:placeName">
        <xsl:choose>
            <xsl:when test="@key">
                <a class="g-entity-link" v-on:click="$router.push({{ name: 'Ort', params: {{ id: '{@key}' }} }})">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:choice[tei:reg and tei:orig]">
        <xsl:apply-templates select="tei:orig"/>
    </xsl:template>

    <xsl:template match="tei:choice[tei:corr and tei:sic]">
        <xsl:apply-templates select="tei:corr"/>
    </xsl:template>

    <xsl:template match="tei:bibl">
        <xsl:choose>
            <xsl:when test="@sameAs">
                <a class="g-entity-link" v-on:click="$router.push({{ name: 'Werk', params: {{ id: '{@key}' }} }})">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <!--TODO: Mehrfache Literaturverweise-->
            <xsl:when test="@corresp">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:unclear">
        <span class="unclear">
            <xsl:apply-templates/>
            <em> (?)</em>
        </span>
    </xsl:template>

    <xsl:template match="tei:gap">
        <span class="gap">[...]</span>
    </xsl:template>

    <xsl:template match="tei:supplied">
        <span class="supplied">[<xsl:apply-templates/>]</span>
    </xsl:template>

    <!-- Popovers: Kommentare, Anstreichungen, Anemerkungen, Erledigungsvermerke -->

    <xsl:template match="tei:seg[@type='comment']">
        <span class="comment"
              data-tippy-content='&lt;b class="card-title"&gt;
                                        Kommentar
                                    &lt;/b&gt;
                                    &lt;div class="card-body"&gt;
                                        {tei:note}
                                  &lt;/div&gt;'>
            <xsl:apply-templates select="tei:orig"/>
        </span>
    </xsl:template>    

    <xsl:template match="tei:note[@place and @hand]">
        <xsl:variable name="place">
            <xsl:choose>
                <xsl:when test="@place='left'"> linken </xsl:when>
                <xsl:when test="@place='right'"> rechten </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="hand">
            <xsl:choose>
                <xsl:when test="@hand='#author'">von Hand des Autors</xsl:when>
                <xsl:when test="@hand='#addressee'">von Hand des Empfängers</xsl:when>
                <xsl:when test="@hand='#unknown'">von unbekannter Hand</xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <span class="btn note place-{@place} margin-right-1"
              data-tippy-content='&lt;b class="card-title"&gt;
                                        Anmerkung 
                                    &lt;/b&gt;
                                    &lt;div&gt;
                                        &lt;small&gt;
                                            am {$place} Rand, {$hand}
                                        &lt;/small&gt;
                                    &lt;/div&gt;
                                    &lt;div class="card-body note-content"&gt;
                                        „{text()}“
                                  &lt;/div&gt;'>
        </span>
    </xsl:template>    

    <xsl:template match="tei:note[@place and tei:metamark[@function]]">
        <xsl:variable name="place">
            <xsl:choose>
                <xsl:when test="@place='left'"> linken </xsl:when>
                <xsl:when test="@place='right'"> rechten </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="metamark">
            <xsl:choose>
                <xsl:when test="tei:metamark/@function='used'">Anstreichung</xsl:when>
                <xsl:when test="tei:metamark/@function='done'">Erledigungsvermerk</xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="hand">
            <xsl:choose>
                <xsl:when test="@hand='#author'">von Hand des Autors</xsl:when>
                <xsl:when test="@hand='#addressee'">von Hand des Empfängers</xsl:when>
                <xsl:when test="@hand='#unknown'">von unbekannter Hand</xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="list">
            <xsl:choose>
                <xsl:when test="matches(tei:metamark/@target, 'list')">, zur gesamten Liste</xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <span class="btn note place-{@place} metamark-{tei:metamark/@function} margin-right-1"
              data-tippy-content='&lt;b class="card-title"&gt;
                                        {$metamark} mit Anmerkung 
                                    &lt;/b&gt;
                                    &lt;div&gt;
                                        &lt;small&gt;
                                            am {$place} Rand, {$hand}{$list}
                                        &lt;/small&gt;
                                    &lt;/div&gt;
                                    &lt;div class="card-body note-content"&gt;
                                        „{text()}“
                                  &lt;/div&gt;'>
        </span>
    </xsl:template>    

    <xsl:template match="tei:add[@place and tei:metamark[@function]]">
        <xsl:variable name="place">
            <xsl:choose>
                <xsl:when test="@place='left'"> linken </xsl:when>
                <xsl:when test="@place='right'"> rechten </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="metamark">
            <xsl:choose>
                <xsl:when test="tei:metamark/@function='used'">Anstreichung</xsl:when>
                <xsl:when test="tei:metamark/@function='done'">Erledigungsvermerk</xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="hand">
            <xsl:choose>
                <xsl:when test="@hand='#author'">von Hand des Autors</xsl:when>
                <xsl:when test="@hand='#addressee'">von Hand des Empfängers</xsl:when>
                <xsl:when test="@hand='#unknown'">von unbekannter Hand</xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="list">
            <xsl:choose>
                <xsl:when test="matches(tei:metamark/@target, 'list')">, zur gesamten Liste</xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <span class="btn add place-{@place} metamark-{tei:metamark/@function} margin-right-1"
              data-tippy-content='&lt;b class="card-title"&gt;
                                        {$metamark}
                                    &lt;/b&gt;
                                    &lt;div&gt;
                                        &lt;small&gt;
                                            am {$place} Rand, {$hand}{$list}
                                        &lt;/small&gt;
                                    &lt;/div&gt;
                                    '>
        </span>
    </xsl:template>    

    <xsl:template match="tei:seg[@xml:id]">
        <span class="seg">
            <xsl:apply-templates/>
        </span>
    </xsl:template>    

    <!-- Listen -->
    <xsl:template match="tei:list">
        <xsl:variable name="indent">
            <xsl:choose>
                <xsl:when test="@rendition='#et'"> ml-4</xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <span class="list{$indent}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:item">
        <span class="list-item">
            <span class="list-item-content">
                <xsl:apply-templates/>
            </span>
        </span>
    </xsl:template>

    <xsl:template match="tei:item[tei:label]">
        <span class="list-item">
            <span class="list-label">
                <xsl:apply-templates select="tei:label"/>
            </span>
            <span class="list-item-content">
                <xsl:apply-templates select="text() | *[not(self::tei:label)]"/>
            </span>
        </span>
    </xsl:template>
    
</xsl:stylesheet>
