<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

<!--
    Studente: Matteo Rosana
    Matricola: 530398
    Corso: codifica di testi 19-20
    Filename: conversion.xsl
    Data: 22-05-2020
-->

    <xsl:output method="html" version="1.0" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/title"/>
                </title>
            </head>
            <body>
                <h2>
                    <xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/respStmt/resp"/>
                </h2>
                <p>
                    <xsl:value-of select="TEI/text/body/p"/>
                </p>
            </body>
        </html>

    </xsl:template>

</xsl:stylesheet>