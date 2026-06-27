;; Silence native-compiler warnings that surface at startup
;; (typically "function not known to be defined" from cross-package
;; references that resolve correctly at runtime).
(setq native-comp-async-query-on-exit nil)
(setq native-comp-warning-on-missing-source nil)
(setq warning-minimum-level :emergency)
(setq warning-suppress-types
      '((native-compiler)
        (bytecomp)
        (use-package)))
