const Immutable = require('immutable-ext')
const { List } = Immutable
const _implements = require('crocks/core/implements')
const isArray = require('crocks/core/isArray')

const _type = require('crocks/core/types').type('Immutable-List')

const _empty = _ => List([])
function fromArray(xs) {
  if(!isArray(xs)) {
    throw new TypeError('List.fromArray: Array required')
  }
  return List(xs)
}

List.prototype.ap_ = function ap_(other) {
  return this.zip(other)
    .map(([f, x]) => f(x))
}
List.prototype.valueOf = function valueOf() {
  return this
}

List.type = _type
List.empty = _empty
List.fromArray = fromArray

List['@@implements'] = _implements(
  ['ap', 'chain', 'concat', 'empty', 'equals', 'map', 'of', 'reduce', 'traverse']
)

module.exports = Immutable
