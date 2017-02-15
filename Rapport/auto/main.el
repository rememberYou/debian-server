(TeX-add-style-hook
 "main"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("report" "a4paper" "12pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("babel" "francais") ("geometry" "margin=4cm") ("doclicense" "type={CC}" "modifier={by-nc-nd}" "version={4.0}" "") ("hyperref" "colorlinks=true" "urlcolor=black" "linkcolor=black")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "src/flyleaf"
    "src/blank"
    "src/license"
    "src/installation"
    "src/gestion"
    "src/references"
    "report"
    "rep12"
    "inputenc"
    "babel"
    "graphicx"
    "enumitem"
    "parskip"
    "textcomp"
    "array"
    "multicol"
    "tabularx"
    "xcolor"
    "geometry"
    "varwidth"
    "eurosym"
    "amsmath"
    "doclicense"
    "hyperref")
   (TeX-add-symbols
    "gray"
    "HRule")
   (LaTeX-add-environments
    "centerspace")
   (LaTeX-add-array-newcolumntypes
    "L"
    "C"
    "R"))
 :latex)

