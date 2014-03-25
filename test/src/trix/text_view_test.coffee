#= require trix/views/text_view
#= require fixtures

module "Trix.TextView"


test "#createElementsForText", ->
  text = fixture("plain")
  elements = getElementsForText(text)
  equal elements.length, 1, "one element for plain string"

  el = elements[0]
  equal el.tagName.toLowerCase(), "span", "container element is a span"
  equal el.trixPosition, 0, "container element has a trixPosition"
  equal el.childNodes.length, 1, "container element has one child node"

  node = el.firstChild
  equal node.nodeType, Node.TEXT_NODE, "child node is a text node"
  equal node.data, text.toString(), "child node contains text string"
  equal node.trixPosition, 0, "child node has a trixPosition property"
  equal node.trixLength, text.getLength(), "child node has a trixLength property"

  elements = getElementsForText(createText(" !"))
  equal elements[0].firstChild.data, "\u00a0!", "leading space replaced with non-breaking space"

  elements = getElementsForText(createText("! "))
  equal elements[0].firstChild.data, "!\u00a0", "trailing space replaced with non-breaking space"

  elements = getElementsForText(createText("!   !"))
  equal elements[0].firstChild.data, "! \u00a0 !", "multiple spaces preserved with non-breaking spaces"

  elements = getElementsForText(createText("Hello\n"))
  equal elements.length, 2, "two elements for string ending with a newline"
  equal elements[0].lastChild.tagName.toLowerCase(), "br", "container element's last child is a BR"
  equal elements[1].tagName.toLowerCase(), "br", "last element is an extra BR"

  elements = getElementsForText(createText(".", bold: true))
  equal elements[0].style["font-weight"], "bold", "font weight is bold"

  elements = getElementsForText(createText(".", italic: true))
  equal elements[0].style["font-style"], "italic", "font style is italic"

  elements = getElementsForText(createText(".", underline: true))
  equal elements[0].style["text-decoration"], "underline", "text decoration is underline"

  elements = getElementsForText(createText(".", selected: true))
  equal elements[0].style["background-color"], "highlight", "background color is highlight"

  elements = getElementsForText(fixture("linkWithFormatting"))
  equal elements.length, 1, "one element for a link with formatting"

  el = elements[0]
  equal el.tagName.toLowerCase(), "a", "container element is an A"
  equal el.getAttribute("href"), "http://basecamp.com", "element has href attribute"
  ok !el.style["font-weight"], "container isn't styled"

  [a, b] = el.childNodes
  equal a.style["font-weight"], "bold", "child element is styled"
  ok !a.getAttribute("href"), "child element has no href attribute"
  ok !b.style["font-weight"], "second child element is not styled"
  ok !b.getAttribute("href"), "second child element has no href attribute"


# Helpers

getElementsForText = (text) ->
  element = document.createElement("div")
  textView = new Trix.TextView element, text
  textView.createElementsForText()

createText = (string, attributes) ->
  Trix.Text.textForStringWithAttributes(string, attributes)
