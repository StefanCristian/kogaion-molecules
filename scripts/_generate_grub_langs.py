#!/usr/bin/python
# -*- coding: utf-8 -*-

# taken from our isolinux gfxboot configuration
# gfxboot-theme-kogaion.git/langnames.inc
langs = [
    [ "en", "en_US", "English" ],
    [ "ro", "ro_RO", "Română" ],
]

keymaps = [
    [ "af", "Afghanistan"],
    [ "al", "Albania"],
    [ "ad", "Andorra"],
    [ "ara", "Arabic"],
    [ "am", "Armenia"],
    [ "es_ast", "Asturian"],
    [ "az", "Azerbaijan"],
    [ "bd", "Bangladesh"],
    [ "by", "Belarus"],
    [ "be", "Belgium"],
    [ "bt", "Bhutan"],
    [ "ba", "Bosnia"],
    [ "br", "Brazil"],
    [ "bg", "Bulgaria"],
    [ "kh", "Cambodia"],
    [ "ca", "Canada"],
    [ "es_cat", "Catalan"],
    [ "cn", "China"],
    [ "cd", "Congo"],
    [ "hr", "Croatia"],
    [ "cz", "Czechia"],
    [ "dk", "Denmark"],
    [ "us_dvorak", "Dvorak"],
    [ "epo", "Esperanto"],
    [ "ee", "Estonia"],
    [ "et", "Ethiopia"],
    [ "fo", "Faroes"],
    [ "fi", "Finland"],
    [ "fr_oss", "France"],
    [ "ge", "Georgia"],
    [ "de", "Germany"],
    [ "gh", "Ghana"],
    [ "gr", "Greece"],
    [ "gn", "Guinea"],
    [ "in_guj", "Gujarati"],
    [ "in_guru", "Gurmukhi"],
    [ "hu", "Hungary"],
    [ "is", "Iceland"],
    [ "in", "India"],
    [ "ir", "Iran"],
    [ "iq", "Iraq"],
    [ "ie", "Ireland"],
    [ "il", "Israel"],
    [ "it", "Italy"],
    [ "jp", "Japan"],
    [ "in_kan", "Kannada"],
    [ "kz", "Kazakhstan"],
    [ "kr", "Korea"],
    [ "tr_ku", "Kurdish"],
    [ "kg", "Kyrgyzstan"],
    [ "la", "Laos"],
    [ "latam", "Latin Amer."],
    [ "lv", "Latvia"],
    [ "lt", "Lithuania"],
    [ "mk", "Macedonia"],
    [ "in_mal", "Malayalam"],
    [ "mv", "Maldives"],
    [ "mt", "Malta"],
    [ "mao", "Maori"],
    [ "mn", "Mongolia"],
    [ "me", "Montenegro"],
    [ "ma", "Morocco"],
    [ "mm", "Myanmar"],
    [ "np", "Nepal"],
    [ "nl", "Netherlands"],
    [ "ng", "Nigeria"],
    [ "no", "Norway"],
    [ "pk", "Pakistan"],
    [ "pl", "Poland"],
    [ "pt", "Portugal"],
    [ "ro", "Romania"],
    [ "ru", "Russia"],
    [ "fi_smi", "Saami (Fin.)"],
    [ "no_smi", "Saami (Nor.)"],
    [ "se_smi", "Saami (Swe.)"],
    [ "sn", "Senegal"],
    [ "rs", "Serbia"],
    [ "sk", "Slovakia"],
    [ "si", "Slovenia"],
    [ "za", "South Africa"],
    [ "es", "Spain"],
    [ "lk", "Sri Lanka"],
    [ "se", "Sweden"],
    [ "ch_fr", "Swiss French"],
    [ "ch", "Swiss German"],
    [ "sy", "Syria"],
    [ "tj", "Tajikistan"],
    [ "in_tam", "Tamil"],
    [ "in_tel", "Telugu"],
    [ "th", "Thailand"],
    [ "tr", "Turkey (Q)"],
    [ "tr_f", "Turkey (F)"],
    [ "tm", "Turkmenistan"],
    [ "gb", "English UK"],
    [ "us", "USA"],
    [ "us_intl", "USA Intl."],
    [ "ua", "Ukraine"],
    [ "uz", "Uzbekistan"],
    [ "vn", "Vietnam"],
]

print("""\
submenu "Language Selection" {
""")

for shortlang, lang, name in langs:
    print("""\
   menuentry "%(name)s" {
      echo "Switching to: $chosen"
      set lang=%(lang)s
      set bootlang=%(lang)s
      export bootlang
      export lang
      configfile /boot/grub/grub.cfg
   }
""" % {'name': name, 'lang': lang,})

print("""\
}
""")

print("""\
submenu "Keyboard Selection" {
""")

for keymap, name in keymaps:
    print("""\
   menuentry "%(name)s" {
      echo "Switching to: $chosen"
      set bootkeymap=%(keymap)s
      export bootkeymap
      configfile /boot/grub/grub.cfg
   }
""" % {'name': name, 'keymap': keymap,})

print("""\
}
""")
