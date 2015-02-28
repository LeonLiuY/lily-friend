CodeMirror.defineSimpleMode("lilypond", {
    // The start state contains the rules that are intially used
    start: [
        // The regex matches the token, the token property contains the type
        {regex: /"(?:[^\\]|\\.)*?"/, token: "string"},
        // You can match multiple tokens at once. Note that the captured
        // groups must span the whole string in this case
        {regex: /\\[a-zA-Z][\w]*/, token: "keyword"},
        {regex: /(?:Staff|Voice|midiInstrument)\b/, token: "atom"},
        // indent and dedent properties guide autoindentation
        {regex: /[\{\[\(]/, indent: true},
        {regex: /[\}\]\)]/, dedent: true}
    ]
});