/** @license ISC License (c) copyright 2016 original and current authors */
/** @author Ian Hofmann-Hicks (evil) */

/* TODO
 - Todo1: add runWith for lazy evaluation or add a Lazy wrapper
 */

/* Modification
 - Fix1: accept Monoid as input not just Entry
 - Fix2: use helper function to enforce style coherence
 */

var _equals = require('crocks/core/equals')
var _implements = require('crocks/core/implements')
var _inspect = require('crocks/core/inspect')
var __type = require('crocks/core/types')
  .type('Writer')
var Pair = require('crocks/core/Pair')

// Fix2
var type = require('crocks/core/type')
var isFunction = require('crocks/core/isFunction')
var isMonoid = require('crocks/core/isMonoid')
var isSameType = require('crocks/core/isSameType')

var constant = function (x) { return function () { return x; }; }

function _Writer(Monoid) {
  if (!isMonoid(Monoid)) {
    throw new TypeError('Writer: Monoid required for construction')
  }

  var _of =
    function (x) {
      return Writer(Monoid.empty()
        .valueOf(), x);
    }

  // Fix2
  var _type =
    function () { return ((__type()) + "( " + type(Monoid) + " )"); }

  function Writer(entry, val) {
    if (arguments.length !== 2) {
      throw new TypeError('Writer: Log entry and a value required')
    }

    var type =
      _type

    var of =
    _of

    var equals =
      function (m) {
        return isSameType(Writer, m) &&
          _equals(m.valueOf(), val);
      }

    var valueOf =
      constant(val)

    // Fix1
    var log = isSameType(Monoid, entry) ?
      constant(entry) :
      constant(Monoid(entry))

    var inspect =
      constant(("Writer(" + (_inspect(log())) + (_inspect(valueOf())) + " )"))

    var read = function () { return Pair(log(), val); }

    function map(fn) {
      if (!isFunction(fn)) {
        throw new TypeError('Writer.map: Function required')
      }

      return Writer(log()
        .valueOf(), fn(valueOf()))
    }

    function ap(m) {
      if (!isFunction(valueOf())) {
        throw new TypeError('Writer.ap: Wrapped value must be a function')
      } else if (!isSameType(Writer, m)) {
        throw new TypeError('Writer.ap: Writer required')
      }

      return chain(function (fn) { return m.map(fn); })
    }

    function chain(fn) {
      if (!isFunction(fn)) {
        throw new TypeError('Writer.chain: Function required')
      }

      var w = fn(valueOf())

      if (!isSameType(Writer, w)) {
        throw new TypeError('Writer.chain: Function must return a Writer')
      }

      return Writer(log()
        .concat(w.log())
        .valueOf(), w.valueOf())
    }

    return {
      inspect: inspect,
      read: read,
      valueOf: valueOf,
      log: log,
      type: type,
      equals: equals,
      map: map,
      ap: ap,
      of: of ,
      chain: chain,
      constructor: Writer
    }
  }

  Writer.of =
    _of

  Writer.type =
    _type

  Writer['@@implements'] = _implements(
    ['ap', 'chain', 'equals', 'map', 'of']
  )

  return Writer
}

module.exports = _Writer
