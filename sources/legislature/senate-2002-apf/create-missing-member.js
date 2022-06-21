const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

// https://stackoverflow.com/questions/196972/convert-string-to-title-case-with-javascript
String.prototype.toTitleCase = function() {
  var i, j, str, lowers, uppers;
  str = this.replace(/([^\W_]+[^\s-]*) */g, function(txt) {
    return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
  });

  // leave as lower-case
  lowers = ['Da', 'De', 'Dos', 'Née', 'Nee'];
  for (i = 0, j = lowers.length; i < j; i++)
    str = str.replace(new RegExp('\\s' + lowers[i] + '\\s', 'g'), 
      function(txt) {
        return txt.toLowerCase();
      });

  // leave as upper-case
  uppers = [];
  for (i = 0, j = uppers.length; i < j; i++)
    str = str.replace(new RegExp('\\b' + uppers[i] + '\\b', 'g'), 
      uppers[i].toUpperCase());

  return str;
}

module.exports = (label,gender) => {
  mem = {
    value: meta.position,
    qualifiers: {
      P2937: meta.term.id,
    },
    references: {
      ...meta.reference,
      P813: new Date().toISOString().split('T')[0],
      P1810: label,
    }
  }

  claims = {
    P31: { value: 'Q5' }, // human
    P106: { value: 'Q82955' }, // politician
    P39: mem,
  }
  if(gender == 'male')   claims['P21'] = 'Q6581097';
  if(gender == 'female') claims['P21'] = 'Q6581072';

  return {
    type: 'item',
    labels: { en: label.toTitleCase(), fr: label.toTitleCase() },
    descriptions: { en: 'Congolese politician' },
    claims: claims,
  }
}
