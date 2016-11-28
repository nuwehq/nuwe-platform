# = require ./lib/fetch

# = require jquery
# = require jquery_ujs
# = require jquery-ui

# = require moment.min
# = require jquery.datetimepicker



# = require_tree ./lib
# = require_tree ./lib/slickgrid
# = require_tree ./lib/slickgrid/plugins

# = require tagit.min
# = require jquery.remotipart
# = require lodash
# = require slick.min

# = require ./lib/parse

# = require editablegrid
# = require editablegrid_renderers
# = require editablegrid_editors
# = require editablegrid_validators
# = require editablegrid_utils
# = require editablegrid_charts


# = require_tree ./modules
# = require_tree ./components

#Code editor

# = require ./codemirror/lib/codemirror
# = require ./codemirror/addon/search/searchcursor
# = require ./codemirror/addon/search/search
# = require ./codemirror/addon/dialog/dialog
# = require ./codemirror/addon/edit/matchbrackets
# = require ./codemirror/addon/edit/closebrackets
# = require ./codemirror/addon/comment/comment
# = require ./codemirror/addon/wrap/hardwrap
# = require ./codemirror/addon/fold/foldcode
# = require ./codemirror/addon/fold/brace-fold
# = require ./codemirror/mode/javascript/javascript
# = require ./codemirror/keymap/sublime

# = require ./clipboard/clipboard

##################################

# please dont use # = require_tree .
# put all new non-component snippets into ./modules

###################################













`
if (!Object.keys) {
  Object.keys = (function() {
    'use strict';
    var hasOwnProperty = Object.prototype.hasOwnProperty,
        hasDontEnumBug = !({ toString: null }).propertyIsEnumerable('toString'),
        dontEnums = [
          'toString',
          'toLocaleString',
          'valueOf',
          'hasOwnProperty',
          'isPrototypeOf',
          'propertyIsEnumerable',
          'constructor'
        ],
        dontEnumsLength = dontEnums.length;

    return function(obj) {
      if (typeof obj !== 'object' && (typeof obj !== 'function' || obj === null)) {
        throw new TypeError('Object.keys called on non-object');
      }

      var result = [], prop, i;

      for (prop in obj) {
        if (hasOwnProperty.call(obj, prop)) {
          result.push(prop);
        }
      }

      if (hasDontEnumBug) {
        for (i = 0; i < dontEnumsLength; i++) {
          if (hasOwnProperty.call(obj, dontEnums[i])) {
            result.push(dontEnums[i]);
          }
        }
      }
      return result;
    };
  }());
}

`

window.App = new Object
