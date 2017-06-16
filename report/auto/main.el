(TeX-add-style-hook
 "main"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "a4paper" "12pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("fontenc" "T1") ("inputenc" "utf8") ("babel" "francais") ("geometry" "margin=2.5cm") ("hyperref" "colorlinks=true" "urlcolor=black" "linkcolor=black") ("doclicense" "type={CC}" "modifier={by-nc-nd}" "version={4.0}" "")))
   (TeX-run-style-hooks
    "latex2e"
    "src/flyleaf_bw"
    "src/blank"
    "src/flyleaf"
    "src/license"
    "src/introduction"
    "src/choices"
    "src/services"
    "src/references"
    "article"
    "art12"
    "fontenc"
    "inputenc"
    "babel"
    "geometry"
    "gensymb"
    "graphicx"
    "listings"
    "lstautogobble"
    "enumitem"
    "parskip"
    "textcomp"
    "tabularx"
    "tikz"
    "colortbl"
    "xcolor"
    "hyperref"
    "doclicense")
   (TeX-add-symbols
    "HRule"))
 :latex)

