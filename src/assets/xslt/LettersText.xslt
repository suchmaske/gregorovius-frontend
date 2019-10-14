<xsl:template match="/">
    <div class="edition-text">
        <xsl:apply-templates select="//tei:body"/>
    </div>
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

<xsl:template match="tei:del[@rendition='#ow']">
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

<xsl:template match="tei:persName | tei:orgName">
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
            <a class="g-entity-link" v-on:click="$router.push({{ name: 'Werk', params: {{ id: '{@sameAs}' }} }})">
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

<!-- Popovers: Kommentare, Anstreichungen, Anmerkungen, Erledigungsvermerke -->

<!--
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
-->
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
    <!-- TODO: Check material design icons -->
    <q-btn 
        color="primary" flat="" outline="" icon="plus"
        class="note metamark-{tei:metamark/@function} margin-right"
    >
        <q-tooltip 
            anchor="center left" self="center right" 
            v-bind:offset="[10, 10]" content-style="font-size: 17px"
            content-class="bg-primary text-white"
        >
            Anmerkung 
            am <xsl:value-of select="$place"/> Rand, 
            <xsl:value-of select="$hand"/> 
            <div class="g-note-content">{text()}</div>
        </q-tooltip>
    </q-btn>
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
    <xsl:variable name="icon-type">
        <xsl:choose>
            <xsl:when test="contains(tei:metamark/@function, 'done')">done</xsl:when>
            <xsl:when test="contains(tei:metamark/@function, 'used')">format_line_spacing</xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:variable>
    <q-btn 
        color="primary" flat="" outline="" icon="{$icon-type}"
        class="note metamark-{tei:metamark/@function} margin-right"
    >
        <q-tooltip 
            anchor="center left" self="center right" 
            v-bind:offset="[10, 10]" content-style="font-size: 17px"
            content-class="bg-primary text-white"
        >
            <xsl:value-of select="$metamark"/> mit Anmerkung 
            am <xsl:value-of select="$place"/> Rand, 
            <xsl:value-of select="$hand"/> 
            <xsl:value-of select="$list"/>
            <div class="g-note-content">{text()}</div>
        </q-tooltip>
    </q-btn>
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
            <xsl:when test="contains(tei:metamark/@target, 'list')">, zur gesamten Liste</xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="icon-type">
        <xsl:choose>
            <xsl:when test="contains(tei:metamark/@function, 'done')">done</xsl:when>
            <xsl:when test="contains(tei:metamark/@function, 'used')">format_line_spacing</xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:variable>

    <q-btn 
        color="primary" flat="" outline="" icon="{$icon-type}"
        class="metamark-{tei:metamark/@function} margin-right"
    >
        <q-tooltip 
            anchor="center left" self="center right" 
            v-bind:offset="[10, 10]" content-style="font-size: 17px"
            content-class="bg-primary text-white"
        >
            <xsl:value-of select="$metamark"/> 
            am <xsl:value-of select="$place"/> Rand, 
            <xsl:value-of select="$hand"/> 
            <xsl:value-of select="$list"/>
        </q-tooltip>
    </q-btn>
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
            <xsl:when test="contains(tei:metamark/@target, 'list')">, zur gesamten Liste</xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="icon-type">
        <xsl:choose>
            <xsl:when test="contains(tei:metamark/@function, 'done')">done</xsl:when>
            <xsl:when test="contains(tei:metamark/@function, 'used')">format_line_spacing</xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:variable>

    <q-btn 
        color="primary" flat="" outline="" icon="{$icon-type}"
        class="metamark-{tei:metamark/@function} margin-right"
    >
        <q-tooltip 
            anchor="center left" self="center right" 
            v-bind:offset="[10, 10]" content-style="font-size: 17px"
            content-class="bg-primary text-white"
        >
            <xsl:value-of select="$metamark"/> 
            am <xsl:value-of select="$place"/> Rand, 
            <xsl:value-of select="$hand"/> 
            <xsl:value-of select="$list"/>
        </q-tooltip>
    </q-btn>
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