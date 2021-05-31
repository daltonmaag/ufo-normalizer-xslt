<?xml version="1.0" encoding="UTF-8"?>
<!--
  Copyright 2021 Dalton Maag Ltd.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8" method="xml"/>
  <xsl:param name="indent-increment" select="'&#9;'"/>
  <xsl:param name="eol" select="'&#xA;'"/>
  <xsl:param name="integer-format" select="'#'"/>
  <xsl:param name="float-precision" select="10"/>
  <xsl:param name="fraction-format"
    select="substring('#################', 1, $float-precision)"/>
  <xsl:param name="float-format"
    select="concat($integer-format, $fraction-format)"/>
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="plist">
        <xsl:text disable-output-escaping="yes"
          >&lt;!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" </xsl:text>
        <xsl:text disable-output-escaping="yes"
          >"http://www.apple.com/DTDs/PropertyList-1.0.dtd"&gt;</xsl:text>
      <xsl:value-of select="$eol"/>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates/>
  </xsl:template>
  <!--
    Template for root plist element.
    Copy plist element, copy all its attributes, apply other templates
    for children and append param $eol, close element.
  -->
  <xsl:template match="/plist">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        <xsl:value-of select="$eol"/>
      </xsl:copy>
  </xsl:template>
  <!--
    Template for root glyph element.
    Copy gylph element, copy all its name and format attributes,
    apply other templates for children and append param $eol, close element.
  -->
  <xsl:template match="/glyph">
    <xsl:copy>
      <xsl:copy-of select="@name"/>
      <xsl:copy-of select="@format"/>
      <xsl:apply-templates select="/glyph/unicode"/>
      <xsl:apply-templates select="/glyph/advance"/>
      <xsl:apply-templates select="/glyph/image"/>
      <xsl:apply-templates select="/glyph/outline"/>
      <xsl:apply-templates select="/glyph/anchor"/>
      <xsl:apply-templates select="/glyph/guideline"/>
      <xsl:apply-templates select="/glyph/lib"/>
      <xsl:apply-templates select="/glyph/note"/>
      <xsl:value-of select="$eol"/>
    </xsl:copy>
  </xsl:template>
  <!--
    Template for unicode element
  -->
  <xsl:template match="/glyph/unicode">
    <xsl:value-of select="$eol"/>
    <xsl:value-of select="$indent-increment"/>
    <xsl:copy>
      <xsl:copy-of select="@hex"/>
    </xsl:copy>
  </xsl:template>
  <!--
    Template for advance element
  -->
  <xsl:template match="/glyph/advance">
    <xsl:value-of select="$eol"/>
    <xsl:value-of select="$indent-increment"/>
    <xsl:copy>
      <xsl:if test="@height">
        <xsl:attribute name="height">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@height"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@width">
        <xsl:attribute name="width">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@width"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  <!--
    Template for image element
  -->
  <xsl:template match="/glyph/image">
    <xsl:value-of select="$eol"/>
    <xsl:value-of select="$indent-increment"/>
    <xsl:copy>
      <xsl:copy-of select="@fileName"/>
      <xsl:if test="@xScale">
        <xsl:attribute name="xScale">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@xScale"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@yScale">
        <xsl:attribute name="yScale">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@yScale"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@xOffset">
        <xsl:attribute name="xOffset">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@xOffset"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@yOffset">
        <xsl:attribute name="yOffset">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@yOffset"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@color">
        <xsl:attribute name="color">
          <xsl:call-template name="colorFormat">
            <xsl:with-param name="value" select="@color"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  <!--
    Template for guideline element
  -->
  <xsl:template match="/glyph/guideline">
    <xsl:value-of select="$eol"/>
    <xsl:value-of select="$indent-increment"/>
    <xsl:copy>
      <xsl:if test="@x">
        <xsl:attribute name="x">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@x"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@y">
        <xsl:attribute name="y">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@y"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@angle">
        <xsl:attribute name="angle">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@angle"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="@name"/>
      <xsl:if test="@color">
        <xsl:attribute name="color">
          <xsl:call-template name="colorFormat">
            <xsl:with-param name="value" select="@color"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="@identifier"/>
    </xsl:copy>
  </xsl:template>
  <!--
    Template for anchor element
  -->
  <xsl:template match="/glyph/anchor">
    <xsl:value-of select="$eol"/>
    <xsl:value-of select="$indent-increment"/>
    <xsl:copy>
      <xsl:copy-of select="@name"/>
      <xsl:if test="@x">
        <xsl:attribute name="x">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@x"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@y">
        <xsl:attribute name="y">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@y"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@color">
        <xsl:attribute name="color">
          <xsl:call-template name="colorFormat">
            <xsl:with-param name="value" select="@color"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="@identifier"/>
    </xsl:copy>
  </xsl:template>
  <!--
    Template for note element
  -->
  <xsl:template match="/glyph/note">
    <xsl:value-of select="$eol"/>
    <xsl:value-of select="$indent-increment"/>
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  <!--
    Generic templace to indent as expected
    Matches any child of plist element or glyph element and comments.
    Write param $eol and param $indent, copy element and its attributes,
    apply other templates for children,
    append param $eol and $indent if there was any child,
    close element.
  -->
  <xsl:template match="/plist//* | /glyph//* | comment()">
    <xsl:param name="indent" select="$indent-increment"/>
    <xsl:value-of select="$eol"/>
    <xsl:value-of select="$indent"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates>
        <xsl:with-param name="indent"
                        select="concat($indent, $indent-increment)"/>
      </xsl:apply-templates>
      <xsl:if test="*">
        <xsl:value-of select="concat($eol, $indent)"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  <!--
    Remove empty outline (also containing empty contours or components)
  -->
  <xsl:template
    match="/glyph/outline[not( descendant::*[node()] or
    descendant-or-self::*/@*[string()] )]"/>
  <!--
    Remove empty contour
  -->
  <xsl:template match="/glyph/outline/contour[not(node())]"/>
  <!--
    Normalize components
  -->
  <xsl:template match="/glyph/outline/component">
    <xsl:param name="indent" select="$indent"/>
    <xsl:value-of select="$eol"/>
    <xsl:value-of select="$indent"/>
    <xsl:copy>
      <xsl:copy-of select="@base"/>
      <xsl:if test="@xScale">
        <xsl:attribute name="xScale">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@xScale"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@xyScale">
        <xsl:attribute name="xyScale">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@xyScale"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@yxScale">
        <xsl:attribute name="yxScale">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@yxScale"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@yScale">
        <xsl:attribute name="yScale">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@yScale"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@xOffset">
        <xsl:attribute name="xOffset">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@xOffset"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@yOffset">
        <xsl:attribute name="yOffset">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@yOffset"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="@identifier"/>
    </xsl:copy>
  </xsl:template>
  <!--
    Normalize contour points
  -->
  <xsl:template match="/glyph/outline/contour/point">
    <xsl:param name="indent" select="$indent"/>
    <xsl:value-of select="$eol"/>
    <xsl:value-of select="$indent"/>
    <xsl:copy>
      <xsl:copy-of select="@name"/>
      <xsl:if test="@x">
        <xsl:attribute name="x">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@x"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@y">
        <xsl:attribute name="y">
          <xsl:call-template name="floatFormat">
            <xsl:with-param name="value" select="@y"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="@type"/>
      <xsl:copy-of select="@smooth"/>
      <xsl:copy-of select="@identifier"/>
    </xsl:copy>
  </xsl:template>
  <!--
    Remove empty lib (also with empty elements)
  -->
  <xsl:template
    match="/glyph/lib[not(descendant::*[not(normalize-space(.)='')])]"/>
  <!--
    Template to replaces <array/> by <array>\n</array>,
    and <dict/> by <dict>\n</dict>
    Matches any array or dict element which doesn’t have any descendants.
  -->
  <xsl:template
    match="//array[count(descendant::*)=0] |
    //dict[count(descendant::*)=0]">
    <xsl:param name="indent" select="$indent-increment"/>
    <xsl:value-of select="$eol"/>
    <xsl:value-of select="$indent"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="$eol"/>
      <xsl:value-of select="$indent"/>
    </xsl:copy>
  </xsl:template>
  <!--
    Keep string with newline
  -->
  <xsl:template match="/glyph//string[string()!='' and normalize-space(.)='']">
    <xsl:param name="indent" select="$indent"/>
    <xsl:value-of select="$eol"/>
    <xsl:value-of select="$indent"/>
    <xsl:copy>
      <xsl:value-of select="$eol"/>
      <xsl:value-of select="$indent"/>
    </xsl:copy>
  </xsl:template>
  <!--
    Template to replace <string/> by <string></string>
  -->
  <xsl:template
    match="/plist//string[not(string())] |
    /glyph//string[not(string())]">
    <xsl:param name="indent" select="$indent"/>
    <xsl:value-of select="$eol"/>
    <xsl:value-of select="$indent"/>
    <xsl:text disable-output-escaping="yes"
      >&lt;string&gt;&lt;/string&gt;</xsl:text>
  </xsl:template>
  <!--
    Template to replace <real>1.0</real> by <integer>1</integer>
  -->
  <xsl:template
    match="/plist//real | /glyph/lib//real">
    <xsl:param name="indent" select="$indent"/>
    <xsl:value-of select="$eol"/>
    <xsl:value-of select="$indent"/>
    <xsl:choose>
      <xsl:when test="number(translate(., '-', '')) mod 1 > 0">
        <xsl:copy>
          <xsl:value-of select="."/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <integer>
          <xsl:value-of select="format-number(., $integer-format)"/>
        </integer>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
    Template to format the color attribute
  -->
  <xsl:template name="colorFormat">
    <xsl:param name="value" select="$value"/>
    <xsl:param name="first" select="substring-before($value, ',')"/>
    <xsl:param name="second" select="substring-before(substring($value, string-length($first) + 2), ',')"/>
    <xsl:param name="third" select="substring-before(substring($value, string-length($first) + string-length($second) + 3), ',')"/>
    <xsl:param name="fourth" select="substring($value, string-length($first) + string-length($second) + string-length($third) + 4)"/>
    <xsl:call-template name="floatFormat">
      <xsl:with-param name="value" select="$first"/>
    </xsl:call-template>
    <xsl:value-of select="','"/>
    <xsl:call-template name="floatFormat">
      <xsl:with-param name="value" select="$second"/>
    </xsl:call-template>
    <xsl:value-of select="','"/>
    <xsl:call-template name="floatFormat">
      <xsl:with-param name="value" select="$third"/>
    </xsl:call-template>
    <xsl:value-of select="','"/>
    <xsl:call-template name="floatFormat">
      <xsl:with-param name="value" select="$fourth"/>
    </xsl:call-template>
  </xsl:template>
  <!--
    Template to format floats
    Since we can’t use XPath 2.0 `if` we have to concat(i, p , f)
    where i is the integer-format
    and p is '.' if value has fractional part and the fraction-format is not empty
    and f is the fraction-format if value has a fractional part

    TODO: round halves like ufonormalizer
  -->
  <xsl:template name="floatFormat">
    <xsl:param name="value" select="$value"/>
    <xsl:value-of select="format-number($value,
      concat(
        $integer-format,
        substring('.', 1, number(
          string-length(substring-after($value, '.')) > 0 and string-length($fraction-format) > 0)),
        substring($fraction-format, 1, number(
          string-length(substring-after($value, '.')) > 0) * string-length($fraction-format))
        )
      )"/>
  </xsl:template>
  <!-- WARNING: this is dangerous. Handle with care -->
  <xsl:template match="text()[normalize-space(.)='']"/>
</xsl:stylesheet>
