(TeX-add-style-hook
 "services"
 (lambda ()
   (TeX-run-style-hooks
    "src/services/ntp"
    "src/services/ssh"
    "src/services/nfs"
    "src/services/samba"
    "src/services/quota"
    "src/services/bd"
    "src/services/srvWeb"
    "src/services/ftp"
    "src/services/dns")
   (LaTeX-add-labels
    "sec:services"))
 :latex)

