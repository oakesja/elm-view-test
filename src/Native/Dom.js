var _user$project$Native_Dom = function () {
  var cheerio = require('cheerio')

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
      if (key === 'className') {
        ret += property('class', node.facts[key])
      } else {
        ret += property(key, node.facts[key])
      }
    }
    return ret + '>'
  }

  var property = function (name, value) {
    return ' ' + name + '="' + value + '"'
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
    return '</' + node.tag + '>'
  }

  var toCheerio = function (html) {
    return cheerio.load(html)
  }

  var find = function (query, cheerioInstance) {
    var nodes = []
    var found = cheerioInstance(query)

    for (var i = 0; i < found.length; i++) {
      nodes.push(cheerio.load(found[i]))
    }

    return _elm_lang$core$Native_List.fromArray(nodes)
  }

  var contains = function (query, cheerioInstance) {
    var nodeText = cheerioInstance.html()
    return nodeText.indexOf(query) > -1
  }

  var findById = function (id, cheerioInstance) {
    var ele = cheerioInstance('#' + id)
    if (ele) {
      // console.log(ele.length)
      return _elm_lang$core$Maybe$Just(ele)
    } else {
      return _elm_lang$core$Maybe$Nothing
    }
  }

  var text = function (cheerioInstance) {
    return cheerioInstance.text()
  }

  return {
    htmlToString: htmlToString,
    stringToCheerio: toCheerio,
    find: F2(find),
    findById: F2(findById),
    contains: F2(contains),
    text: text
  }
}()
