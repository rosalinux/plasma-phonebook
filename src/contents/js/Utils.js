function getChar(s) {
    return s.substr(0, 1).toUpperCase();
}

function getColorForContact(ch) {
    var colors = {
        "0": "green",
        "1": "red",
        "2": "yellow",
        "3": "blue",
        "4": "orange",
        "5": "olive",
        "6": "violet"
    };

    var russian_alphabet = {
        "А" : "#46852A",
        "Б" : "#FF0000",
        "В" : "#F0C350",
        "Г" : "#6BA452",
        "Д" : "#5D9BBE",
        "Е" : "#EC6259",
        "Ё" : "#EC6259",
        "Ж" : "#7DAECA",
        "З" : "#5A9F9F",
        "И" : "#12694A",
        "Й" : "#CF8A57",
        "К" : "#7DAECA",
        "Л" : "#EC6259",
        "М" : "#437431",
        "Н" : "#12694A",
        "О" : "#F0C350",
        "П" : "#5A9F9F",
        "Р" : "#CF8A57",
        "С" : "#A678AA",
        "Т" : "#7DAECA",
        "У" : "#5A9F9F",
        "Ф" : "#F0C350",
        "Х" : "#FF0000",
        "Ц" : "#5D9BBE",
        "Ч" : "#7DAECA",
        "Ш" : "#EC6259",
        "Щ" : "#46852A",
        "Ъ" : "#12694A",
        "Ь" : "#F0C350",
        "Ы" : "#CF8A57",
        "Э" : "#46852A",
        "Ю" : "#EC6259",
        "Я" : "#5A9F9F",
    };
    if (russian_alphabet[ch.toUpperCase()[0]])
        return russian_alphabet[ch.toUpperCase()[0]];
    else
        return colors[ch.toUpperCase().charCodeAt(0) % 7];
}

function getSuffix(c) {
    if (c > 9 && c < 21)
        return i18n("ов");

    let l = c % 10;

    if (l == 1)
        return i18n("");

    if (l == 2 || l == 3 || l == 4)
        return i18n("a");

    return i18n("ов");
}

function makeFormattedName(n, m, f) {
    return n + " " + m + " " + f;
}

function parseFormattedName(n, i) {
    let a = n.split(" ");
    if (i < a.length) {
        if (i > 1) {
            a.shift();
            a.shift();
            return a.join(" ");
        } else
            return a[i];
    }
    else
        return ""
}

function makeDate(d) {
    let a = d.split(".");
    if (a.length > 2)
        return new Date(a[2], a[1] + 1, a[0]);
    else
        return new Date();
}
