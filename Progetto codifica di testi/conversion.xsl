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
                <p><b><xsl:value-of select="tei:resp" /></b>: &#160;
                    <xsl:for-each select="tei:name">
                        <xsl:apply-templates/> &#160;
                    </xsl:for-each>
                </p>
            </xsl:for-each>
            <p><b><xsl:value-of select="//tei:editionStmt/tei:respStmt/tei:resp"/></b>: &#160;
            <xsl:value-of select="//tei:editionStmt/tei:respStmt/tei:name"/>
            </p>
            <p><b>Publisher</b>: &#160;
            <xsl:value-of select="//tei:publicationStmt/tei:publisher"/></p>
        </div>
        <p style="text-align: center;"><xsl:value-of select="//tei:editionStmt/tei:respStmt/tei:note"/></p>

    </xsl:template>


    <xsl:template match="tei:text/tei:body">
        <div id = "title_section">
            <h1>Trascrizione del documento</h1><br/>
        </div>
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="//tei:div[@type = 'retro']">
        <br /><hr width="85%"/><br />
    </xsl:template>


    <xsl:template match="tei:TEI/tei:teiHeader//tei:profileDesc" >
        <h1>Informazioni sulla lettera</h1>
        <p><b>Mittente</b>: </p>
            <xsl:for-each select="tei:correspDesc/tei:correspAction[@type = 'sent']" >
                <p><xsl:value-of select="current()" /></p>
            </xsl:for-each>
        <p><b>Destinatario</b>: </p>
            <xsl:for-each select="tei:correspDesc/tei:correspAction[@type = 'received']" >
                <p>
                    <xsl:if test="current()/tei:date[@cert = 'unknown']">
                        <xsl:value-of select="concat(current()/tei:persName, ', ' ,current()/tei:date)" />
                    </xsl:if>
                </p>
            </xsl:for-each>
        <p><b>Timbri</b>: <xsl:value-of select="//tei:certainty[@target = '#LL1_19_envelope']/tei:desc"/></p>
        <p><b>Lingua</b>: <xsl:value-of select="//tei:language"/></p>
    </xsl:template>


    <xsl:template match="tei:TEI/tei:text/tei:back">
        <h2>Elenco bibliografia</h2>
        <ul>
            <xsl:for-each select="current()//tei:bibl/tei:ref/tei:bibl">
            <li>  
                <span><xsl:value-of select="tei:author" />, <xsl:value-of select="tei:date" />, pag. <xsl:value-of select="tei:citedRange" /></span>
            </li>
            </xsl:for-each>
        </ul>
    </xsl:template>


    <xsl:template match="tei:div[@type = 'fronte']/">
        <xsl:if test="current()//tei:damage">
            <xsl:choose>
                <xsl:when test="current()//parent::tei:ab[@subtype = 'addition']">
                    <div class="paratext">
                        <p><xsl:apply-templates/></p>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <div class="transcription">
                        <p><xsl:apply-templates/></p>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    

    <xsl:template match="tei:term | tei:placeName | tei:rs | tei:persName | tei:orgName">
        <span class="target">
            <b><xsl:apply-templates /></b>
            <span class="focus">
                <xsl:if test="name() = 'term'">
                    <xsl:value-of select="//tei:term[@xml:id= current()]/@subtype" />
                </xsl:if>
                <xsl:if test="name() = 'placeName'">
                    City: <xsl:value-of select="//tei:place[concat('#',@xml:id) = current()/@ref]/@xml:id" />
                    Country: <xsl:value-of select="//tei:place[concat('#',@xml:id) = current()/@ref]/tei:country" />
                </xsl:if> 
                <xsl:if test="name() = 'orgName'">
                    <xsl:attribute name="style">font-style: normal;</xsl:attribute>
                    Type: <xsl:value-of select="current()/@type" />
                    Reference: <xsl:value-of select="//tei:org[concat('#',@xml:id) = current()/@ref]/tei:orgName[@type = 'main']" />
                    City: <xsl:value-of select="//tei:org[concat('#',@xml:id) = current()/@ref]/tei:placeName" />
                </xsl:if> 
                <xsl:if test="current()[@type='person']">
                    <xsl:choose>
                        <xsl:when test="//tei:person[concat('#',@xml:id) = current()/@ref]//tei:roleName = 'Re'">
                            Reference: <xsl:value-of select="//tei:person[concat('#',@xml:id) = current()/@ref]//tei:addName"/>
                        </xsl:when>
                        <xsl:otherwise>
                            Reference: <xsl:value-of select="//tei:person[concat('#',@xml:id) = current()/@ref]/tei:persName/tei:forename" />&#160;<xsl:value-of select="//tei:person[concat('#',@xml:id) = current()/@ref]/tei:persName/tei:surname" />
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="current()/@ref = //tei:relation/@active" >
                        Relation: <xsl:value-of select="//tei:relation[@active = current()/@ref]/@name" />
                    </xsl:if>        
                </xsl:if>
                <xsl:if test="current()[@type = 'work']">
                    <xsl:attribute name="style">font-style: normal;</xsl:attribute>
                    Type: <xsl:value-of select="current()/@type" />
                    Organization: <xsl:value-of select="//tei:bibl[concat('#',@xml:id) = current()/@ref]/tei:orgName" />
                    City: <xsl:value-of select="//tei:bibl[concat('#',@xml:id) = current()/@ref]/tei:placeName" />
                </xsl:if>
                <xsl:if test="current()[@role = 'composer']">
                    Role: <xsl:value-of select="current()/@role" />
                </xsl:if>
            </span>
        </span> 
    </xsl:template>


    <xsl:template match="tei:date">
        <xsl:value-of select="current()"/>
    </xsl:template>


    <xsl:template match="tei:roleName">
        <xsl:value-of select="current()"/>
    </xsl:template>



    <xsl:template match="tei:choice">
        <xsl:if test="descendant::tei:corr">
            <span>
                <xsl:attribute name="class">corr</xsl:attribute>
                <xsl:value-of select="descendant::tei:corr" />
            </span>
            </xsl:if>
            <xsl:if test="child::tei:abbr">
                <span class="abbr_exp">
                    <span>
                        <xsl:attribute name="class">abbr</xsl:attribute>
                        <xsl:value-of select="child::tei:abbr" />
                    </span>
                <xsl:if test="descendant::tei:expan">
                    <span>
                        <xsl:attribute name="class">expan</xsl:attribute>
                        <xsl:value-of select="concat(' (Exten.: ', child::tei:expan, ')')" />
                    </span>
                </xsl:if>
                </span>
        </xsl:if>
    </xsl:template>
    

    <xsl:template match="tei:unclear">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="concat('unclear_',current()/@cert)"/>
            </xsl:attribute>
            <xsl:apply-templates />
        </span>
    </xsl:template>

    <xsl:template match="tei:gap">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="name()"/>
            </xsl:attribute>
            <xsl:text>&#91;&#46;&#46;&#46;</xsl:text><xsl:apply-templates /><xsl:text>&#93;</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="tei:supplied">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="name()"/>
            </xsl:attribute>
            <xsl:text>&#60;</xsl:text><xsl:apply-templates /><xsl:text>&#62;</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend='underline'">
                <i><xsl:apply-templates/></i>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:lb">
        <br/><xsl:if test="./@n">
            <span>
                <xsl:attribute name="class">
                    <xsl:value-of select="substring(@facs, 2)"/>
                </xsl:attribute>
                <xsl:value-of select="current()/@n" />
            </span>
        </xsl:if>
    </xsl:template>


    <xsl:template match="tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc">
        <div id="info_doc">
            <h1>Informazioni sul documento</h1>
            <p><b>Locazione</b>: 
                <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:country" />, 
                <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:settlement" />,
                ID: <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:idno[@type = 'inventory']" />, 
                <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:altIdentifier/tei:idno[@type= 'collocation']" />.  
            </p>
            <p class="long_text"><b>Descrizione</b>: 
                <xsl:for-each select="tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:p" > 
                    <p class="long_text"><xsl:value-of select="current()" /></p> 
                </xsl:for-each>
                <p><xsl:value-of select="tei:msDesc/tei:physDesc//tei:seal" /></p>
            </p>
            <p><b>Materiale</b>: <xsl:value-of select="tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:material" /> </p>
            <p><b>Dimensioni</b>:
                <xsl:value-of select="tei:msDesc/tei:physDesc/tei:objectDesc//tei:height" /> x 
                <xsl:value-of select="tei:msDesc/tei:physDesc/tei:objectDesc//tei:width" /> 
                <xsl:value-of select="tei:msDesc/tei:physDesc/tei:objectDesc//tei:dimensions/@unit" /></p>
            <p><b>Deterioramento</b>:
                <xsl:value-of select="tei:msDesc/tei:physDesc/tei:objectDesc//tei:condition" />
            </p>
        </div>
    </xsl:template>



</xsl:stylesheet>