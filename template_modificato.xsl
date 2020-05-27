<?xml version="1.0" encoding="UTF-8"?>

<!--
    Studente: Matteo Rosana
    Matricola: 530398
    Corso: codifica di testi 19-20
    Filename: template_modificato.xsl
    Data: 26-05-2020
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" encoding="UTF-8" indent="yes" />
    <xsl:template match="/">
        <html>
            <head>
               
                <title>
                    <xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/title" />
                </title>

                 <link rel="stylesheet" type="text/css" href="./mycss.css" />
                <style>
                    h1{
                        color:blue;
                    }
                </style>
            </head>
            <body>
                <xsl:variable name="color_font">color:red</xsl:variable>
                <div class="index">
                    <h1 style="$color_font">Responsabile</h1>
                    <xsl:call-template name="resp">
                        <xsl:with-param name="nomeresp" select = "TEI/teiHeader/fileDesc/respStmt/name" />
                    </xsl:call-template>
                    <h1 style="$color_font">INDEX</h1>
                    <ul>
                        <xsl:apply-templates select="//div[@type='chapter']" mode="index" />
                    </ul>
                </div>
                <div>
                    <xsl:apply-templates select="child::node()" />
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="div" mode="index">
        <ul>
            <xsl:for-each select=".">
                <li>
                    <xsl:value-of select="head" />
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template match="titleStmt/title">
        <h2>
            <xsl:value-of select="." />
        </h2>
    </xsl:template>
    <xsl:template match="div/head">
        <h3>
            <xsl:value-of select="." />
        </h3>
    </xsl:template>

<xsl:template match="teiHeader">
    <span>[identificativo del documento: <xsl:value-of select="@xml:id" />]</span>
</xsl:template>

<xsl:template name="resp">
    <xsl:param name="nomeresp" />
    <p><xsl:value-of select="$nomeresp" /></p>
</xsl:template>

</xsl:stylesheet>