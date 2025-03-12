;; Authenticity Verification Contract
;; Facilitates the process of confirming artwork legitimacy

(define-map verifiers
  { address: principal }
  {
    name: (string-ascii 64),
    organization: (string-ascii 64),
    active: bool
  }
)

(define-map certificates
  { artwork-id: uint, certificate-id: uint }
  {
    verifier: principal,
    date: uint,
    authentic: bool,
    notes: (string-ascii 256)
  }
)

(define-map certificate-counters
  { artwork-id: uint }
  { count: uint }
)

;; Register as a verifier
(define-public (register-verifier
                (name (string-ascii 64))
                (organization (string-ascii 64)))
  ;; Store verifier data
  (ok (map-set verifiers
    { address: tx-sender }
    {
      name: name,
      organization: organization,
      active: true
    }
  ))
)

;; Deactivate verifier
(define-public (deactivate-verifier)
  (let
    ((verifier (default-to
                 { name: "", organization: "", active: false }
                 (map-get? verifiers { address: tx-sender }))))

    ;; Only self can deactivate
    (ok (map-set verifiers
      { address: tx-sender }
      (merge verifier { active: false })
    ))
  )
)

;; Issue authenticity certificate
(define-public (issue-certificate
                (artwork-id uint)
                (authentic bool)
                (notes (string-ascii 256)))
  (let
    ((verifier (default-to
                 { name: "", organization: "", active: false }
                 (map-get? verifiers { address: tx-sender })))
     (counter (default-to
                { count: u0 }
                (map-get? certificate-counters { artwork-id: artwork-id }))))

    ;; Verifier must be active
    (if (get active verifier)
      (begin
        ;; Increment certificate counter
        (map-set certificate-counters
          { artwork-id: artwork-id }
          { count: (+ (get count counter) u1) }
        )

        ;; Store certificate
        (ok (map-set certificates
          { artwork-id: artwork-id, certificate-id: (+ (get count counter) u1) }
          {
            verifier: tx-sender,
            date: block-height,
            authentic: authentic,
            notes: notes
          }
        ))
      )
      (err u403)
    )
  )
)

;; Get verifier details
(define-read-only (get-verifier (verifier-address principal))
  (map-get? verifiers { address: verifier-address })
)

;; Get certificate details
(define-read-only (get-certificate (artwork-id uint) (certificate-id uint))
  (map-get? certificates { artwork-id: artwork-id, certificate-id: certificate-id })
)

;; Get latest certificate
(define-read-only (get-latest-certificate (artwork-id uint))
  (let
    ((counter (default-to
                { count: u0 }
                (map-get? certificate-counters { artwork-id: artwork-id }))))

    (if (> (get count counter) u0)
      (map-get? certificates { artwork-id: artwork-id, certificate-id: (get count counter) })
      none
    )
  )
)

;; Check if artwork is authentic
(define-read-only (is-artwork-authentic (artwork-id uint))
  (let
    ((counter (default-to
                { count: u0 }
                (map-get? certificate-counters { artwork-id: artwork-id }))))

    (if (> (get count counter) u0)
      (let
        ((certificate (default-to
                        { verifier: tx-sender, date: u0, authentic: false, notes: "" }
                        (map-get? certificates { artwork-id: artwork-id, certificate-id: (get count counter) }))))

        (get authentic certificate)
      )
      false
    )
  )
)

