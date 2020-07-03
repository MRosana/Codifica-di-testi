<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output
        method="html"
        encoding="UTF-8"
        indent="yes"
        omit-xml-declaration="yes" />



    <xsl:template match="/">
        <html>
            <head>
                <title><xsl:value-of select="//tei:title"/></title>
                <link href="style.css" rel="stylesheet" type="text/css"/>
                <link href="https://fonts.googleapis.com/css?family=Alegreya"
                    rel="stylesheet"/>
                <link href="https://fonts.googleapis.com/css?family=Lora"
                    rel="stylesheet"/>
                <script src="interactions.js"/>
            </head>
            <body>
                <header>
                    <h1>Lettera <xsl:value-of select="concat(//tei:idno[@type = 'inventory'], ' ', //tei:edition)" /></h1>
                    <h2><xsl:value-of select="//tei:title"/></h2>
                </header>
                <div id="img_letter"> <!--Div contenenti le scansioni-->
                    <img id="small_letter">
                        <xsl:attribute name="src">
                            <xsl:value-of select="//tei:graphic/@url"/>
                        </xsl:attribute>
                        <xsl:attribute name="usemap">
                            <xsl:value-of select="concat('#', //tei:graphic/@n)"/>
                        </xsl:attribute>
                    </img>
                    <map> <!-- Estrazione delle coordinate per la mappatura della lettera-->
                        <xsl:attribute name="name">
                            <xsl:value-of select="//tei:graphic/@n" />
                        </xsl:attribute>
                        <xsl:for-each select="//tei:surface[@n='2']/tei:zone">
                            <area shape="rect">
                                <xsl:attribute name="coords">
                                <xsl:value-of select="concat(@ulx, ',', @uly, ',', @lrx, ',', @lry)"/>
                                </xsl:attribute>
                                <xsl:attribute name="class">
                                <xsl:value-of select="current()/@xml:id"/>
                                </xsl:attribute>
                            </area>
                        </xsl:for-each>
                    </map>
                    <div id="big_letter"></div>
                </div>
                <xsl:apply-templates select="tei:TEI/tei:text/tei:body" />
                <div id="info_letter">
                    <xsl:apply-templates select="tei:TEI/tei:teiHeader//tei:profileDesc" />
                    <xsl:apply-templates select="tei:TEI/tei:text/tei:back"/>
                </div>
                <xsl:apply-templates select="tei:TEI/tei:teiHeader//tei:sourceDesc" />
                <footer>
                    <xsl:apply-templates select="tei:TEI/tei:teiHeader//tei:titleStmt" />
                </footer>
            </body>
        </html>
    </xsl:template>


    <xsl:template match="tei:TEI/tei:teiHeader//tei:titleStmt" > 
        <div id="resp">
            <xsl:for-each select="tei:respStmt">
                <xsl:element name="p">
                    <xsl:element name="b">
                        <xsl:value-of select="tei:resp" />
                    </xsl:element>
                    <xsl:text>: &#160;</xsl:text>
                    <xsl:for-each select="tei:name">
                        <xsl:apply-templates/>
                        <xsl:text> &#160;</xsl:text>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
            <xsl:element name="p">
                <xsl:element name="b">
                    <xsl:value-of select="//tei:editionStmt/tei:respStmt/tei:resp"/>
                </xsl:element>
                <xsl:text>: &#160;</xsl:text>
                <xsl:value-of select="//tei:editionStmt/tei:respStmt/tei:name"/>
            </xsl:element>
            <xsl:element name="p">
                <xsl:element name="b">
                    <xsl:text>Publisher:</xsl:text>
                </xsl:element>
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="//tei:publicationStmt/tei:publisher"/>
            </xsl:element>
            <xsl:element name="p">
                <xsl:attribute name="style">
                    <xsl:text>text-align: center;</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="//tei:editionStmt/tei:respStmt/tei:note"/>
            </xsl:element>
        </div>
    </xsl:template>


    <xsl:template match="tei:text/tei:body">
        <div id = "title_section">
            <xsl:element name="h1">
                <xsl:text>Trascrizione del documento</xsl:text>
            </xsl:element><br/>
        </div>
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="//tei:div[@type = 'retro']">
        <br /><hr width="85%"/><br />
    </xsl:template>


    <xsl:template match="tei:TEI/tei:teiHeader//tei:profileDesc" >
        <xsl:element name="h1">
            <xsl:text>Informazioni sulla lettera</xsl:text>
        </xsl:element>
        <xsl:element name="p">
            <xsl:element name="b">
                <xsl:text>Mittente:</xsl:text>
            </xsl:element>
        </xsl:element>
        <xsl:for-each select="tei:correspDesc/tei:correspAction[@type = 'sent']" >
            <xsl:element name="p">
                <xsl:value-of select="current()" />
            </xsl:element>
        </xsl:for-each>
        <xsl:element name="p">
            <xsl:element name="b">
                <xsl:text>Destinatario:</xsl:text>
            </xsl:element>
        </xsl:element>
        <xsl:for-each select="tei:correspDesc/tei:correspAction[@type = 'received']" >
            <xsl:element name="p">
                <xsl:if test="current()/tei:date[@cert = 'unknown']">
                    <xsl:value-of select="concat(current()/tei:persName, ', ' ,current()/tei:date)" />
                </xsl:if>
            </xsl:element>
        </xsl:for-each>
        <xsl:element name="p">
            <xsl:element name="b">
                <xsl:text>Timbri: </xsl:text>
            </xsl:element>
            <xsl:value-of select="//tei:certainty[@target = '#LL1_19_envelope']/tei:desc"/>
        </xsl:element>
        <xsl:element name="p">
            <xsl:element name="b">
                <xsl:text>Lingua: </xsl:text>
            </xsl:element>
            <xsl:value-of select="//tei:language"/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="tei:TEI/tei:text/tei:back">
        <xsl:element name="h2">
            <xsl:text>Elenco bibliografia</xsl:text>
        </xsl:element>
        <xsl:element name="ul">
            <xsl:for-each select="current()//tei:bibl/tei:ref/tei:bibl">
                <xsl:element name="li">
                    <xsl:element name="span">
                        <xsl:value-of select="tei:author" />
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="tei:date" />
                        <xsl:text>, pag. </xsl:text>
                        <xsl:value-of select="tei:citedRange" />
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>


    <xsl:template match="tei:div[@type = 'fronte']/">
        <xsl:if test="current()//tei:damage">
            <xsl:choose>
                <xsl:when test="current()//parent::tei:ab[@subtype = 'addition']">
                    <div class="paratext">
                        <xsl:element name="p">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <div class="transcription">
                        <xsl:element name="p">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    

    <xsl:template match="tei:term | tei:placeName | tei:rs | tei:persName | tei:orgName">
        <xsl:element name="span">
            <xsl:attribute name="class">
                target
            </xsl:attribute>
            <xsl:element name="b">
                <xsl:apply-templates />
            </xsl:element>
            <xsl:element name="span">
                <xsl:attribute name="class">
                    focus
                </xsl:attribute>
                <xsl:if test="name() = 'term'">
                    <xsl:value-of select="//tei:term[@xml:id= current()]/@subtype" />
                </xsl:if>
                <xsl:if test="name() = 'placeName'">
                    <xsl:text>City: </xsl:text><xsl:value-of select="//tei:place[concat('#',@xml:id) = current()/@ref]/@xml:id" />
                    <xsl:text> Country: </xsl:text><xsl:value-of select="//tei:place[concat('#',@xml:id) = current()/@ref]/tei:country" />
                </xsl:if> 
                <xsl:if test="name() = 'orgName'">
                    <xsl:attribute name="style">font-style: normal;</xsl:attribute>
                    <xsl:text>Type: </xsl:text><xsl:value-of select="current()/@type" />
                    <xsl:text> Reference: </xsl:text><xsl:value-of select="//tei:org[concat('#',@xml:id) = current()/@ref]/tei:orgName[@type = 'main']" />
                    <xsl:text> City: </xsl:text><xsl:value-of select="//tei:org[concat('#',@xml:id) = current()/@ref]/tei:placeName" />
                </xsl:if> 
                <xsl:if test="current()[@type='person']">
                    <xsl:choose>
                        <xsl:when test="//tei:person[concat('#',@xml:id) = current()/@ref]//tei:roleName = 'Re'">
                            <xsl:text>Reference: </xsl:text><xsl:value-of select="//tei:person[concat('#',@xml:id) = current()/@ref]//tei:addName"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> Reference: </xsl:text><xsl:value-of select="//tei:person[concat('#',@xml:id) = current()/@ref]/tei:persName/tei:forename" /><xsl:text>&#160;</xsl:text><xsl:value-of select="//tei:person[concat('#',@xml:id) = current()/@ref]/tei:persName/tei:surname" />
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="current()/@ref = //tei:relation/@active" >
                        <xsl:text> Relation: </xsl:text><xsl:value-of select="//tei:relation[@active = current()/@ref]/@name" />
                    </xsl:if>        
                </xsl:if>
                <xsl:if test="current()[@type = 'work']">
                    <xsl:attribute name="style">font-style: normal;</xsl:attribute>
                    <xsl:text>Type: </xsl:text><xsl:value-of select="current()/@type" />
                    <xsl:text> Organization: </xsl:text><xsl:value-of select="//tei:bibl[concat('#',@xml:id) = current()/@ref]/tei:orgName" />
                    <xsl:text> City: </xsl:text><xsl:value-of select="//tei:bibl[concat('#',@xml:id) = current()/@ref]/tei:placeName" />
                </xsl:if>
                <xsl:if test="current()[@role = 'composer']">
                    <xsl:text>Role: </xsl:text><xsl:value-of select="current()/@role" />
                </xsl:if>
            </xsl:element>
        </xsl:element> 
    </xsl:template>


    <xsl:template match="tei:date">
        <xsl:value-of select="current()"/>
    </xsl:template>


    <xsl:template match="tei:roleName">
        <xsl:value-of select="current()"/>
    </xsl:template>



    <xsl:template match="tei:choice">
        <xsl:if test="descendant::tei:corr">
            <xsl:element name="span">
                <xsl:attribute name="class">corr</xsl:attribute>
                <xsl:value-of select="descendant::tei:corr" />
            </xsl:element>
        </xsl:if>
        <xsl:if test="child::tei:abbr">
            <xsl:element name="span">
                <xsl:attribute name="class">abbr_exp</xsl:attribute>
                <xsl:element name="span">
                    <xsl:attribute name="class">abbr</xsl:attribute>
                    <xsl:value-of select="child::tei:abbr" />
                </xsl:element>
                <xsl:if test="descendant::tei:expan">
                    <xsl:element name="span">
                        <xsl:attribute name="class">expan</xsl:attribute>
                        <xsl:value-of select="concat(' (Exten.: ', child::tei:expan, ')')" />
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    

    <xsl:template match="tei:unclear">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="concat('unclear_',current()/@cert)"/>
            </xsl:attribute>
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:gap">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="name()"/>
            </xsl:attribute>
            <xsl:text>&#91;&#46;&#46;&#46;</xsl:text><xsl:apply-templates /><xsl:text>&#93;</xsl:text>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:supplied">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="name()"/>
            </xsl:attribute>
            <xsl:text>&#60;</xsl:text><xsl:apply-templates /><xsl:text>&#62;</xsl:text>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend='underline'">
                <xsl:element name="i">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:lb">
        <br/><xsl:if test="./@n">
            <xsl:element name="span">
                <xsl:attribute name="class">
                    <xsl:value-of select="substring(@facs, 2)"/>
                </xsl:attribute>
                <xsl:value-of select="current()/@n" />
            </xsl:element>
        </xsl:if>
    </xsl:template>


    <xsl:template match="tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc">
        <div id="info_doc">
            <xsl:element name="h1">
                <xsl:text>Informazioni sul documento</xsl:text>
            </xsl:element>
            <xsl:element name="p">
                <xsl:element name="b">
                    <xsl:text>Locazione: </xsl:text>
                </xsl:element> 
                <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:country" />, 
                <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:settlement" />,
                <xsl:text>ID: </xsl:text><xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:idno[@type = 'inventory']" /><xsl:text>, </xsl:text> 
                <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:altIdentifier/tei:idno[@type= 'collocation']" />.  
            </xsl:element>
            <xsl:element name="p">
                <xsl:attribute name="class">long_text</xsl:attribute>
                <xsl:element name="b">
                    <xsl:text>Descrizione:</xsl:text>
                </xsl:element>
                <xsl:for-each select="tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:p" > 
                    <xsl:element name="p">
                        <xsl:attribute name="class">long_text</xsl:attribute>
                        <xsl:value-of select="current()" />
                    </xsl:element>
                </xsl:for-each>
                <xsl:element name="p">
                    <xsl:value-of select="tei:msDesc/tei:physDesc//tei:seal" />
                </xsl:element>
            </xsl:element>
            <xsl:element name="p">
                <xsl:element name="b">
                    <xsl:text>Materiale: </xsl:text>
                </xsl:element>
                <xsl:value-of select="tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:material" />
            </xsl:element>
            <xsl:element name="p">
                <xsl:element name="b">
                    <xsl:text>Dimensioni: </xsl:text>
                </xsl:element>
                <xsl:value-of select="tei:msDesc/tei:physDesc/tei:objectDesc//tei:height" /> <xsl:text> x </xsl:text> 
                <xsl:value-of select="tei:msDesc/tei:physDesc/tei:objectDesc//tei:width" /> 
                <xsl:value-of select="tei:msDesc/tei:physDesc/tei:objectDesc//tei:dimensions/@unit" />
            </xsl:element>
            <xsl:element name="p">
                <xsl:element name="b">
                    <xsl:text>Deterioramento: </xsl:text>
                </xsl:element>
                <xsl:value-of select="tei:msDesc/tei:physDesc/tei:objectDesc//tei:condition" />
            </xsl:element>
        </div>
    </xsl:template>


</xsl:stylesheet>