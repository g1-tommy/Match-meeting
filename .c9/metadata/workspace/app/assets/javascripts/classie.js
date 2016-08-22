{"filter":false,"title":"classie.js","tooltip":"/app/assets/javascripts/classie.js","undoManager":{"mark":0,"position":0,"stack":[[{"start":{"row":0,"column":0},"end":{"row":80,"column":0},"action":"insert","lines":["/*!"," * classie - class helper functions"," * from bonzo https://github.com/ded/bonzo"," * "," * classie.has( elem, 'my-class' ) -> true/false"," * classie.add( elem, 'my-new-class' )"," * classie.remove( elem, 'my-unwanted-class' )"," * classie.toggle( elem, 'my-class' )"," */","","/*jshint browser: true, strict: true, undef: true */","/*global define: false */","","( function( window ) {","","'use strict';","","// class helper functions from bonzo https://github.com/ded/bonzo","","function classReg( className ) {","  return new RegExp(\"(^|\\\\s+)\" + className + \"(\\\\s+|$)\");","}","","// classList support for class management","// altho to be fair, the api sucks because it won't accept multiple classes at once","var hasClass, addClass, removeClass;","","if ( 'classList' in document.documentElement ) {","  hasClass = function( elem, c ) {","    return elem.classList.contains( c );","  };","  addClass = function( elem, c ) {","    elem.classList.add( c );","  };","  removeClass = function( elem, c ) {","    elem.classList.remove( c );","  };","}","else {","  hasClass = function( elem, c ) {","    return classReg( c ).test( elem.className );","  };","  addClass = function( elem, c ) {","    if ( !hasClass( elem, c ) ) {","      elem.className = elem.className + ' ' + c;","    }","  };","  removeClass = function( elem, c ) {","    elem.className = elem.className.replace( classReg( c ), ' ' );","  };","}","","function toggleClass( elem, c ) {","  var fn = hasClass( elem, c ) ? removeClass : addClass;","  fn( elem, c );","}","","var classie = {","  // full names","  hasClass: hasClass,","  addClass: addClass,","  removeClass: removeClass,","  toggleClass: toggleClass,","  // short names","  has: hasClass,","  add: addClass,","  remove: removeClass,","  toggle: toggleClass","};","","// transport","if ( typeof define === 'function' && define.amd ) {","  // AMD","  define( classie );","} else {","  // browser global","  window.classie = classie;","}","","})( window );",""],"id":1}]]},"ace":{"folds":[],"scrolltop":593.0000514984131,"scrollleft":0,"selection":{"start":{"row":80,"column":0},"end":{"row":80,"column":0},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":{"row":286,"mode":"ace/mode/javascript"}},"timestamp":1471448762203,"hash":"782b9564f015a2ec7bdf9c89e238fab9b44bd587"}