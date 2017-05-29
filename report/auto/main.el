(TeX-add-style-hook
 "main"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "a4paper" "12pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("fontenc" "T1") ("inputenc" "utf8") ("babel" "francais") ("geometry" "margin=2.5cm") ("hyperref" "colorlinks=true" "urlcolor=black" "linkcolor=black") ("doclicense" "type={CC}" "modifier={by-nc-nd}" "version={4.0}" "")))
   (add-to-list 'LaTeX-verbatim-environments-local "lstlisting")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "lstinline")
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
    "HRule")
   (LaTeX-add-array-newcolumntypes
    "L"
    "C"
    "R")
   (LaTeX-add-xcolor-definecolors
    "black"
    "currentLine"
    "selection"
    "grey"
    "comment"
    "red"
    "orange"
    "yellow"
    "green"
    "aqua"
    "blue"
    "purple"
    "bleuSkype"
    "jauneSnapchat"))
 :latex)

