(TeX-add-style-hook
 "homework"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("homework" "twoside" "11pt")))
   (TeX-run-style-hooks
    "latex2e"
    "homework11"
    "graphicx"
    "physics"))
 :latex)

