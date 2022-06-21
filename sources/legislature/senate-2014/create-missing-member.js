const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (label) => {
  mem = {
    value: meta.position,
    qualifiers: {
      P580: meta.term.start,
      P582: meta.term.end,
      P2715: meta.term.election,
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

  return {
    type: 'item',
    labels: { en: label, fr: label },
    descriptions: { en: 'Congolese politician' },
    claims: claims,
  }
}
