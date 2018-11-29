<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/">
  <xsl:output indent="yes"/>


  <xsl:include href=".xslt-datura/common.xsl"/>
  <!--
  List of fields:
    id *
    title *
    caption
    category *
    sub_category *
    location * (multi?)
    description
    keywords *
    date *
    medium
    size
    creator
    collection
  -->

  <xsl:template match="/">
    <add>
      <doc>
        <field name="id">
          <!-- Get the filename -->
          <xsl:variable name="filename" select="tokenize(base-uri(.), '/')[last()]"/>

          <!-- Split the filename using '\.' -->
          <xsl:variable name="filenamepart" select="substring-before($filename, '.xml')"/>

          <!-- Remove the file extension -->
          <xsl:value-of select="$filenamepart"/>
        </field>

        <field name="title">
          <xsl:value-of select="//title[@type='main'][1]"/>
        </field>

        <!-- caption: not for texts -->

        <field name="category">
          <!--<xsl:if test="/TEI/teiHeader/profileDesc/textClass/keywords[@n='category']/term[1]">
            <xsl:value-of
              select="/TEI/teiHeader/profileDesc/textClass/keywords[@n='category']/term[1]"/>
          </xsl:if>-->
          <xsl:text>texts</xsl:text>
        </field>

        <xsl:if test="/TEI/teiHeader/profileDesc/textClass/keywords[@n='subcategory']/term[1][normalize-space()]">
          <field name="sub_category">
            <xsl:if test="/TEI/teiHeader/profileDesc/textClass/keywords[@n='subcategory']/term[1]">
              <xsl:value-of
                select="/TEI/teiHeader/profileDesc/textClass/keywords[@n='subcategory']/term[1]"/>
            </xsl:if>
          </field>
        </xsl:if>

        <!-- pages: not for texts -->

        <xsl:if test="/TEI/teiHeader/profileDesc/textClass/keywords[@n='places']/term[normalize-space()]">
          <xsl:for-each select="/TEI/teiHeader/profileDesc/textClass/keywords[@n='places']/term">
            <field name="location">
              <xsl:value-of select="."/>
            </field>
          </xsl:for-each>
        </xsl:if>

        <!-- description: not for texts -->

        <xsl:if test="/TEI/teiHeader/profileDesc/textClass/keywords[@n='keywords']/term[normalize-space()]">
          <xsl:for-each
            select="/TEI/teiHeader/profileDesc/textClass/keywords[@n='keywords']/term">
            <field name="keywords">
              <xsl:value-of select="."/>
            </field>
          </xsl:for-each>
        </xsl:if>

        <field name="date">
          <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl[1]/date"/>
        </field>

        <field name="dateNormalized">
          <xsl:call-template name="extractDate">
            <xsl:with-param name="date"
              select="/TEI/teiHeader/fileDesc/sourceDesc/bibl[1]/date/@when"/>
          </xsl:call-template>
        </field>

        <!-- medium: not for texts -->

        <!--<xsl:for-each select="/TEI/teiHeader/profileDesc/textClass/keywords[@n='people']/term">
        <field name="person">
            <xsl:value-of select="."/>
        </field>
        </xsl:for-each>-->

        <!-- medium: not for texts -->

        <!-- size: not for texts -->

        <xsl:if test="/TEI/teiHeader/fileDesc/titleStmt/author[1][normalize-space()]">
          <xsl:for-each
            select="/TEI/teiHeader/fileDesc/titleStmt/author[1]">
            <field name="creator">
              <xsl:value-of select="."/>
            </field>
          </xsl:for-each>
        </xsl:if>

        <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='j'][normalize-space()]">
          <xsl:for-each
            select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='j']">
            <field name="publication">
              <xsl:value-of select="."/>
            </field>
          </xsl:for-each>
        </xsl:if>

        <!-- collection: not for texts -->

        <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/history/provenance[1][normalize-space()]">
          <xsl:for-each
            select="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/history/provenance[1]">
            <field name="provenance">
              <xsl:value-of select="."/>
            </field>
          </xsl:for-each>
        </xsl:if>

        <field name="text">
          <xsl:value-of select="//text"/>
        </field>
      </doc>
    </add>

  </xsl:template>

</xsl:stylesheet>
