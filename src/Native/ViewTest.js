var _user$project$Native_ViewTest = function () {
  // var STYLE_KEY = 'STYLE'
  // var EVENT_KEY = 'EVENT'
  // var ATTR_KEY = 'ATTR'
  // var ATTR_NS_KEY = 'ATTR_NS'

  var VOID_ELEMENTS = {
    'area': true,
    'base': true,
    'br': true,
    'col': true,
    'command': true,
    'embed': true,
    'hr': true,
    'img': true,
    'input': true,
    'keygen': true,
    'link': true,
    'meta': true,
    'param': true,
    'source': true,
    'track': true,
    'wbr': true
  }

  var htmlToString = function (html) {
    return toHtml(html)
  }

  var toHtml = function (node) {
    if (node.type === 'text')
      return node.text
    if (node.type === 'node')
      return openTag(node) + tagContent(node) + closeTag(node)
    if (node.type === 'keyed-node')
      return openTag(node) + keyedTagContent(node) + closeTag(node)
    if (node.type === 'tagger')
      return toHtml(node.node)
    if (node.type === 'thunk')
      return toHtml(node.thunk())
    return ''
  }

  var openTag = function (node) {
    var ret = '<' + node.tag
    for (var key in node.facts) {
      ret += createAttribute(key, node.facts[key])
    }
    return ret + '>'
  }

  var specialAttributeNames = {
    acceptCharset: 'accept-charset',
    className: 'class',
    defaultValue: 'value',
    htmlFor: 'for',
    httpEquiv: 'http-equiv'
  }

  var createAttribute = function (key, value) {
    if (key === 'EVENT') {
      return ''
    }
    if (key === 'ATTR') {
      var attrName = Object.keys(value)[0]
      return ' ' + attrName + '="' + value[attrName] + '"'
    }
    if (key === 'STYLE') {
      var style = ''
      for (var attr in value) {
        style += paramCase(attr) + ': ' + value[attr] + '; '
      }
      if (style.length > 0) {
        return ' style="' + style.trim() + '"'
      }   else {
        return ''
      }
    }
    var attrName = (specialAttributeNames[key] || key)
    return ' ' + attrName + '="' + value + '"'
  }

  var paramCase = function (str) {
    var newStr = ''
    for (var i = 0; i < str.length; i++) {
      var c = str.charAt(i)
      if (c.match(/[A-Z]/)) {
        newStr += '-'
      }
      newStr += c.toLowerCase()
    }
    return newStr
  }

  var tagContent = function (node) {
    var content = ''
    for (var i = 0; i < node.children.length; i++) {
      content += toHtml(node.children[i])
    }
    return content
  }

  var keyedTagContent = function (node) {
    var content = ''
    for (var i = 0; i < node.children.length; i++) {
      content += toHtml(node.children[i]._1)
    }
    return content
  }

  var closeTag = function (node) {
    if (VOID_ELEMENTS[node.tag]) {
      return ''
    }
    return '</' + node.tag + '>'
  }

  var toDomNode = function (node) {
    if (node.type === 'text')
      return _user$project$ViewTest$Text(_user$project$ViewTest$TextNode(node.text))
    if (node.type === 'node') {
      var attrs = []
      for (var key in node.facts) {
        attrs.push(A2(
          _user$project$ViewTest$Attribute,
          key,
          node.facts[key]
        ))
      }
      var children = []
      for (var i = 0; i < node.children.length; i++) {
        children.push(toDomNode(node.children[i]))
      }
      var domNode = A3(
        _user$project$ViewTest$TaggedNode,
        node.tag,
        _elm_lang$core$Native_List.fromArray(attrs),
        _elm_lang$core$Native_List.fromArray(children)
      )
      return _user$project$ViewTest$Tag(domNode)
    }
    if (node.type === 'keyed-node')
      return {}
    if (node.type === 'tagger')
      return {}
    if (node.type === 'thunk')
      return {}
    return {}
  }

  return {
    htmlToString: htmlToString,
    toDomNode: toDomNode
  }
}()
