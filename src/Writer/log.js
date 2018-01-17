/** @license ISC License (c) copyright 2016 original and current authors */
/** @author Ian Hofmann-Hicks (evil) */

var isFunction = require('crocks/core/isFunction')

function log(m) {
  if(!(m && isFunction(m.log))) {
    throw new TypeError('log: Writer required')
  }

  return m.log()
}

module.exports = log
