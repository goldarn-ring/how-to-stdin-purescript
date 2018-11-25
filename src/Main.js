"use strict";

var readlineSync = require('readline-sync')

exports.readLineSync = function () {
  return readlineSync.question('> ')
}
